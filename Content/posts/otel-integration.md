---
date: 2024-12-16 14:00
description: Getting started with Vapor 4 and OpenTelemetry
tags: vapor, otel, prometheus, grafana
image: /static/images/posts/otel-integration.svg
author: Paul
authorImageURL: /author-images/paul.jpg
---

# Instrumenting Vapor 4 with Swift OTel

## Observability

In complex systems it's often a good thing to be able to figure out why the system is behaving in a certain way without having to look into the code. When we want to be able to have a more high level view of what happens in the application without opening up the black box, we're looking for observability. Observability is the concept of collecting data about a system's execution and internal state, based on the data it generates.

In more practical terms, observability is made up of 

- Logs: exact details of an event, e.g an HTTP request, its method, time etc.;
- Metrics: instant measurement representing some system state, such as number of HTTP requests/second;
- Traces: a series of breadcrumbs which, if tied together, show the flow of data (such as a request) across the application, for instance how it gets routed across various internal components in the application.

**Instrumenting** a system means adding observability capabilities. The idea is the code emits the data which then must be collected and sent to a backend observability system. 

Before starting, let's give a small overview of our end goal. In Vapor 4, logging is automatic, and this post's aim is to add metrics collection to our system, but collecting tracing data is not much different. 

![Vapor OTel Architecture](/static/images/posts/otel-integration.svg)

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

To implement this approach, we use the [Swift Prometheus](https://github.com/swift-server/swift-prometheus) package. This package is really simple: all it does is collect and export the SwiftMetrics emitted metrics in a Prometheus format. First things first we'll want to add the package to our application in the `Package.swift` file:

```swift
let package = Package(
    name: "..."
    dependencies: [
        .package(url: "https://github.com/swift-server/swift-prometheus.git", from: "2.0.0"),
    ],
	
    // ...
    
    targets: [
         .executableTarget(
             name: "...",
             dependencies: [
                 .product(name: "Prometheus", package: "swift-prometheus"),
             ]
        )
    ]
)
```

once that's done, we can configure the collector
```swift
let factory = PrometheusMetricsFactory()
MetricsSystem.bootstrap(factory)
```

and finally add the metrics-emitting route:

```swift
router.get("metrics") { _ in
	var buffer = [UInt8]()
	(MetricsSystem.factory as? PrometheusMetricsFactory)?.registry.emit(into: &buffer)
	return String(bytes: buffer, encoding: .utf8) ?? ""
}
```

and that's it! Once we build and run we should see some metrics being printed out. This endpoint will be used by our Prometheus instance.

