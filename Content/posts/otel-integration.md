---
date: 2024-12-16 14:00
description: Getting started with Vapor 4 and OpenTelemetry
tags: vapor, otel, prometheus, grafana
image: /static/images/posts/otel-integration-arch.svg
author: Paul
authorImageURL: /author-images/paul.jpg
---

# Instrumenting Vapor 4 with Swift OTel

This tutorial will guide you through setting up a Vapor 4 application with OpenTelemetry, collecting metrics about the application and its queue workers, and visualizing the data in Grafana.

## Observability

In complex systems it's often a good thing to be able to figure out why the system is behaving in a certain way without having to look into the code. When we want to be able to have a more high level view of what happens in the application without opening up the black box, we're looking for observability. Observability is the concept of collecting data about a system's execution and internal state, based on the data it generates.

In more practical terms, observability is made up of 

- Logs: exact details of an event, e.g an HTTP request, its method, time etc.;
- Metrics: instant measurement representing some system state, such as number of HTTP requests/second;
- Traces: a series of breadcrumbs which, if tied together, show the flow of data (such as a request) across the application, for instance how it gets routed across various internal components in the application.

**Instrumenting** a system means adding observability capabilities. The idea is the code emits the data which then must be collected and sent to a backend observability system. 

Before starting, let's give a small overview of our end goal. In Vapor 4, logging is automatic, and this post's aim is to add metrics collection to our system, but collecting tracing data is not much different. 

<!-- ![Vapor OTel Architecture](/static/images/posts/otel-integration-arch.svg) -->
![Vapor OTel Architecture](/Resources/static/images/posts/Blank%20diagram-3.svg)

As you can see here there's a bunch of things going on, but we'll get into each of them. 

1. Our Vapor HTTP server (which can be either an API or a web app) directly sends data to Prometheus, the metrics database;
2. To make matters spicier, we want to collect metrics from our queue workers too, which are separate instances. In this case the OpenTelemetry (OTel) collector collects the data and sends it to the same Prometheus instance;
3. Along with the collector and the Prometheus DB, inside of the Docker Compose configuration we have Grafana, which provides a nice user interface to interact with the collected data.

Let's dive in.

### Emitting metrics

The first step is to actually emit the metrics. You can think of it as logging: Vapor already logs a lot of internal things when they happen, such as incoming HTTP requests, database interactions or external connection state, and it does this via the Swift Log package. Luckily, such a package exists for metrics too and it's called [Swift Metrics](https://github.com/apple/swift-metrics). Vapor integrates with this package already and provides most of the basic metrics you'll need already, such as number of incoming HTTP requests, number of erroring requests, duration of requests and more. So unless you need anything more specific you should be fine.

In our example we also want to gather job data and, again, the Vapor queues package does this for us. The metrics collected should be enough to understand which jobs are failing, which ones are taking longer than expected, which queues are getting stuck and more. In a bit we'll dive into how we can actually use this data, but for now emitting data works without having to touch anything!

> If you want to add more metrics you'll need to add the Swift Metrics package to your application and just add the needed metrics. You can check out the package's README for more info.

### Collecting metrics

This is probably the most complex part as it's not always clear in which direction the data should go. There's different approaches to collecting data and in this example we actually use both, but the fundamental idea is the same, data goes out of our application and into a backend observability system. More specifically, we need to store this data in a metrics database, and in this example we'll be using Prometheus. 

Our example uses two different approaches:

1. The first one is the HTTP server which provides a route that the Prometheus instance can periodically make a request to;
2. The second one is the queue workers periodically pushing the data to a collector, and the Prometheus instance scraping the collector.

Let's dive into both approaches.

#### HTTP Server

This first approach is the simplest one, because all we're doing is opening up a `/metrics` endpoint which Prometheus is configured to scrape on its own, every x seconds. This also allows Vapor to ignore the Prometheus instance completely and really just treat it as a normal client, which is good, especially in a distributed system, as we don't want to burden the API more than we have to. However, the catch is obviously that we need to be running an HTTP server to handle the requests.

To implement this approach, we use the [Swift Prometheus](https://github.com/swift-server/swift-prometheus) package. This package is really simple: all it does is collect and export the SwiftMetrics emitted metrics in a Prometheus format. First things first we'll want to add the package to our application in the `Package.swift` file, both in the package's dependencies and in the target's dependencies:

```swift
.package(url: "https://github.com/swift-server/swift-prometheus.git", from: "2.0.0")
```
```swift
.product(name: "Prometheus", package: "swift-prometheus")
```

Once that's done, we can configure the collector:

```swift
let factory = PrometheusMetricsFactory()
MetricsSystem.bootstrap(factory)
```

And finally add the metrics-emitting route:

```swift
router.get("metrics") { _ in
	var buffer = [UInt8]()
	(MetricsSystem.factory as? PrometheusMetricsFactory)?.registry.emit(into: &buffer)
	return String(bytes: buffer, encoding: .utf8) ?? ""
}
```

That's it! Once we build and run we should see some metrics being printed out. This endpoint will be used by our Prometheus instance.

To configure Prometheus, we need to create a `prometheus.yml` configuration file in the same directory as the `docker-compose.yml` file. This is the initial configuration:

```yaml
scrape_configs:
  - job_name: 'api'
    scrape_interval: 30s
    static_configs:
      - targets: ["host.docker.internal:8080"]
```

This configuration tells Prometheus to scrape the `/metrics` endpoint on the host machine every 30 seconds.

> Note: The `host.docker.internal` address is a special address that Docker uses to refer to the host machine from within a container. This supposes that the Vapor application is running on the host machine and not in a container.

Then we can add Prometheus to our `docker-compose.yml` file:

```yaml
services:
  prometheus:
    image: prom/prometheus
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
    ports:
      - 9090:9090
```

This should be enough to get Prometheus up and running and scraping the Vapor application.
We'll update both the `docker-compose.yml` and the `prometheus.yml` files later on to include the queue workers.

#### Queue Workers

The second approach is a bit more complex. The idea is that the queue workers are separate instances from the HTTP server, and they don't have an HTTP server running. This means we can't just have Prometheus scrape an endpoint, because there isn't one. Instead, we need to push the data from the queue workers to a collector, and then have Prometheus scrape the collector.

The collector we're using is the OpenTelemetry Collector. This is a an intermediary that can collect data from various sources and send it to various destinations. In our case, we're going to configure it to collect data from the queue workers and send it to Prometheus. To do this, we'll be using the [Swift OTel package](https://github.com/swift-otel/swift-otel). This package is a Swift implementation of the OpenTelemetry specification, which is a standard for collecting observability data. 

First of all we need to add the package to our application in the `Package.swift` file:

```swift
.package(url: "https://github.com/swift-otel/swift-otel.git", from: "0.1.0")
```
```swift
.product(name: "OTel", package: "swift-otel"),
.product(name: "OTLPGRPC", package: "swift-otel"),
```

Configuring OTel will be a bit more complex than Prometheus, as we want to differentiate between the HTTP server and the queue workers. To do this, we can add an extension to Vapor's `Environment`:

```swift
import Vapor

extension Environment {
    enum AppMode {
        case http
        case queue(name: String)
    }
    
    var appMode: AppMode {
        if
            CommandLine.arguments.contains("queues") ||
            CommandLine.arguments.contains("queue")
        {
            guard let name = CommandLine.arguments.firstIndex(of: "--queue") else {
                return .queue(name: "default")
            }
            
            return .queue(name: CommandLine.arguments[name + 1])
        } else {
            return .http
        }
    }
}
```

This extension will allow us to differentiate between the HTTP server and the queue workers. We can then use this in the `configure.swift` file to configure OTel:

```swift
switch app.environment.appMode {
case .http:
    // If running the HTTP server, use swift-prometheus
    if !app.environment.name.contains("testing") {
        let factory = PrometheusMetricsFactory()
        MetricsSystem.bootstrap(factory)
    }
case .queue(let name):
    // If running a queue worker, use swift-otel
    let environment = OTelEnvironment.detected()
    let resourceDetection = OTelResourceDetection(detectors: [
        OTelProcessResourceDetector(),
        .manual(OTelResource(attributes: ["service.name": "\(name)-queue"]))
    ])
    let resource = await resourceDetection.resource(environment: environment)
    
    // Configure OTel to export metrics to Prometheus
    let registry = OTelMetricRegistry()
    let exporter = try OTLPGRPCMetricExporter(
        configuration: .init(environment: environment)
    )
    let metrics = OTelPeriodicExportingMetricsReader(
        resource: resource,
        producer: registry,
        exporter: exporter,
        configuration: .init(
            environment: environment,
            exportInterval: .seconds(5)
        )
    )
    MetricsSystem.bootstrap(OTLPMetricsFactory(registry: registry))
    app.lifecycle.use(OTelMetricsExporterLifecycle(metrics: metrics))
}
```

Copy-pasting this now will yield an error, as we haven't defined the `OTelMetricsExporterLifecycle` yet. This is a lifecycle that will start and stop the metrics exporter when the application starts and stops. We can define it as follows:

```swift
actor OTelMetricsExporterLifecycle: LifecycleHandler {
    let metrics: OTelPeriodicExportingMetricsReader<ContinuousClock>
    private var task: Task<Void, Error>?
    
    init(metrics: OTelPeriodicExportingMetricsReader<ContinuousClock>) {
        self.metrics = metrics
    }
    
    public func didBootAsync(_ application: Application) async throws {
        task = Task {
            try await metrics.run()
        }
    }
    
    func shutdownAsync(_ application: Application) async {
        task?.cancel()
    }
}
```

This is a bit of a hack to be able to use the swift-service-lifecycle approach swift-otel uses in Vapor 4, which doesn't implement it.

This is enough to get the queue workers to start exporting metrics to Prometheus via the OpenTelemetry Collector. However we need to configure the collector to actually collect the data and send it to Prometheus. We can do this by creating a `collector-config.yml` file in the same directory as the `docker-compose.yml` file:

```yaml
# Receive metrics on localhost:4317
receivers:
  otlp:
    protocols:
      grpc:
        endpoint: otel-collector:4317

# Open up localhost:8888 for Prometheus to scrape
exporters:
  prometheus:
    endpoint: otel-collector:7070
    const_labels:
      collector: "otel-collector"

service:
  pipelines:
    metrics:
      receivers: [otlp]
      exporters: [prometheus]
```

And finally add the collector to the `docker-compose.yml` file:

```yaml
otel-collector:
  image: otel/opentelemetry-collector-contrib
  command: ["--config=/etc/otel-collector-config.yml"]
  ports:
    - "4317:4317" # For receiving metrics
    - "7070:7070" # For Prometheus to scrape
  volumes:
    - "./otel-collector-config.yml:/etc/otel-collector-config.yml"
```

To be sure that Prometheus gets spun up after the collector, we can add a `depends_on` key to the Prometheus service in the `docker-compose.yml` file:

```yaml
prometheus:
  image: prom/prometheus
  depends_on:
    - otel-collector
  # ...
```

Now, the queue workers should be exporting metrics to the OpenTelemetry Collector, which in turn should be exporting them to Prometheus. Prometheus should be scraping the `/metrics` endpoint on the HTTP server, and the queue workers should be exporting metrics to Prometheus via the OpenTelemetry Collector.

### Visualizing the data

The final step is to visualize the data. For this we'll be using Grafana. Grafana is a tool that allows you to create dashboards to visualize your data. Let's create a simple configuration for Grafana in a `grafana.yml` file:

```yaml
apiVersion: 1

datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    orgId: 1
    url: http://prometheus:9090
    isDefault: true
```

This configuration tells Grafana to use Prometheus as a data source. We can then add the Grafana service to the `docker-compose.yml` file:

```yaml
grafana:
  image: grafana/grafana
  depends_on:
    - prometheus
  ports:
    - "3000:3000" # Grafana UI
  volumes:
    - ./grafana.yml:/etc/grafana/provisioning/datasources/grafana.yml
```

And that's it! Once we start the Docker Compose stack, we should be able to access Grafana at `http://localhost:3000` and start creating dashboards to visualize the data.
