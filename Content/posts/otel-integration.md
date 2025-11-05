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

### Observability

In complex systems it's often a good thing to be able to figure out why the system is behaving in a certain way without having to look into the code. When we want to be able to have a more high level view of what happens in the application without opening up the black box, we're looking for **observability**. Observability is the concept of collecting information about a system's execution and internal state, based on the data it generates.

In more practical terms, observability is made up of 

- **Logs**: exact details of an event, e.g an HTTP request, its method, time etc.;
- **Metrics**: instant measurement representing some system state, such as number of HTTP requests/second;
- **Traces**: a series of breadcrumbs (spans) which, if tied together, show the flow of data (such as a request) across the application, for instance how it gets routed across various internal components in the application, or across different services.

**Instrumenting** a system means adding observability capabilities. The idea is the code emits the data which then must be collected and sent to a backend observability system. In this blog post we'll focus on metrics, but the same principles apply to logs and traces as well.

### Gathering metrics

The first step is gathering the metrics from our app's flow. Fortunately for us this is the easiest step, as, just like logs with swift-log, Vapor comes with built-in support for metrics using the [swift-metrics](https://github.com/apple/swift-metrics) package.

The metrics created by Vapor include things like request counts, response times, and error rates, all of which are essential for understanding the health and performance of your application. 

> You can also emit your own custom metrics using the same package. To do this, check out the [Swift Metrics documentation](https://swiftpackageindex.com/apple/swift-metrics/2.7.1/documentation/coremetrics). Since Vapor already embeds it, you don't need to configure anything, just add your own metrics where you need them and they will be emitted along with the built-in ones.

### Emitting Metrics

The next step is sending the emitted metrics to a service that can process and store them. To do that we'll be using something known as a sidecar, which is a separate process that runs alongside your application and collects the metrics emitted by it. In our case, we'll be using the [OpenTelemetry Collector](https://opentelemetry.io/). The OTel Collector is a vendor-agnostic tool to receive, process, and export telemetry data. It can receive data in various formats, process it, and export it to various backends.

To interact with the OTel Collector we'll need a client that speaks the same language, which is the OpenTelemetry protocol (OTLP). Luckily, at the time of writing, the [swift-otel](https://github.com/swift-otel/swift-otel) package has just hit version 1.0 and is right up our alley.

Let's add the package to our dependencies in the `Package.swift` file:

```swift
.package(url: "https://github.com/swift-otel/swift-otel.git", from: "1.0.0"),
```

and then add it to our target dependencies:

```swift
.target(
    name: "App",
    dependencies: [
        .product(name: "OTel", package: "swift-otel"),
    ]
),
```


While the package is designed to work with swift-service-lifecycle which is not Vapor 4's favourite lunch buddy, we can integrate it manually into our application's lifecycle. To do this we can create a `LifecycleHandler` that will start and stop the OTel metrics exporter when the application starts and stops.

```swift
import OTel
import ServiceLifecycle
import Vapor

actor OTelLifecycleHandler: LifecycleHandler {
    let observability: any Service
    private var task: Task<Void, any Error>?
    
    init(observability: some Service) {
        self.observability = observability
    }
    
    public func didBootAsync(_ application: Application) async throws {
        task = Task {
            try await observability.run()
        }
    }
    
    func shutdownAsync(_ application: Application) async {
        task?.cancel()
    }
}
```

Then we can configure OTel in our `configure.swift` file:

```swift
var config = OTel.Configuration.default
config.serviceName = "your_app_name"
config.logs.enabled = false
config.traces.enabled = false
config.metrics.otlpExporter.protocol = .grpc

let observability = try OTel.bootstrap(configuration: config)
app.lifecycle.use(OTelLifecycleHandler(observability: observability))
```

We'll also need to tell Vapor where to send the metrics to. By default, OTel sends data to `http://localhost:4317`, which is where our OTel Collector will be listening. Although you don't need to, we'll still define it explicitly in an env var, so we can change it easily later if needed:

```
OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4317
```

And that's it! Now our Vapor application is set up to emit metrics to an OpenTelemetry Collector. We can set up a local instance of the OpenTelemetry Collector using Docker Compose. First, let's create a folder called `observability` in the root of our project. Then we need a bit of configuration for the OTel collector, so let's create a file called `otel-collector-config.yaml` in the `observability` folder with the following content:

```yaml
# Receive metrics on :4317
receivers:
  otlp:
    protocols:
      grpc:
        endpoint: :4317

# Export metrics to Prometheus
exporters:
  prometheusremotewrite:
    endpoint: "http://prometheus:9090/api/v1/write"

service:
  pipelines:
    metrics:
      receivers: [otlp]
      exporters: [prometheusremotewrite]
```

### Storing and using the data with Prometheus

Now that our application is best friends with the collector, we need to tell the collector what to do with the metrics. The collector is only a middleware that receives the data, processes it, and exports it to a backend of our choice. In this case, we'll be using [Prometheus](https://prometheus.io/) as our backend. Prometheus is basically a database that collects and stores metrics data and provides a powerful query language called PromQL to analyze it. We already set up the exporter in the OTel collector configuration in the last snippet (the `prometheusremotewrite` exporter), so now we need to configure Prometheus itself to scrape the metrics from the collector.

In the same `observability` folder, create a file called `prometheus-config.yaml` with the following content:

```yaml
services:
  otel-collector:
    image: otel/opentelemetry-collector-contrib:latest
    command: ["--config=/etc/otel-collector-config.yaml"]
    ports:
      - "4317:4317"
      - "7070:7070"
    volumes:
      - ./otel-collector-config.yaml:/etc/otel-collector-config.yaml

  prometheus:
    image: prom/prometheus
    entrypoint:
      - "/bin/prometheus"
      - "--log.level=debug"
      - "--config.file=/etc/prometheus/prometheus.yml"
      - "--storage.tsdb.path=/prometheus"
      - "--web.console.libraries=/usr/share/prometheus/console_libraries"
      - "--web.console.templates=/usr/share/prometheus/consoles"
      - "--web.enable-remote-write-receiver"
    depends_on:
      - otel-collector
    ports:
      - 9090:9090
```

> Note: You can also use the docker-compose.yml file provided by Vapor and just add to it. If you are, you should change the `OTEL_EXPORTER_OTLP_ENDPOINT` environment variable to point to `http://otel-collector:4317` instead of `localhost`, since the services will be running in the same Docker network.

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
    - "3000:3000"
  volumes:
    - ./grafana.yml:/etc/grafana/provisioning/datasources/grafana.yml
```

And that's it! Once the Docker Compose stack is running, you should be able to access Grafana at `http://localhost:3000` log in with `admin` as username and password, and start creating dashboards to visualize the data. We will even provide you with a sample dashboard JSON that you can import into Grafana to get started quickly. Just head to the Dashboards section in Grafana, click on "Import", and paste the JSON content:

```json
{
  "id": 1,
  "title": "Test Dashboard",
  "timezone": "browser",
  "schemaVersion": 39,
  "version": 1,
  "refresh": "5s",
  "panels": [
    {
      "type": "timeseries",
      "title": "Request Rate (req/s) by Path",
      "id": 1,
      "datasource": "Prometheus",
      "targets": [
        {
          "refId": "A",
          "expr": "sum(rate(http_requests_total[1m])) by (path)",
          "legendFormat": "{{path}}"
        }
      ],
      "options": {
        "legend": {
          "displayMode": "table",
          "placement": "right"
        }
      },
      "gridPos": { "h": 7, "w": 12, "x": 0, "y": 0 }
    },
    {
      "type": "timeseries",
      "title": "Request Duration (p95) by Path",
      "id": 2,
      "datasource": "Prometheus",
      "targets": [
        {
          "refId": "A",
          "expr": "histogram_quantile(0.95, sum(rate(http_request_duration_seconds_bucket[5m])) by (le, path))",
          "legendFormat": "{{path}} p95"
        }
      ],
      "fieldConfig": { "defaults": { "unit": "s" } },
      "options": {
        "legend": {
          "displayMode": "table",
          "placement": "right"
        }
      },
      "gridPos": { "h": 7, "w": 12, "x": 12, "y": 0 }
    },
    {
      "type": "timeseries",
      "title": "Total Requests",
      "id": 3,
      "datasource": "Prometheus",
      "targets": [
        {
          "refId": "A",
          "expr": "sum(http_requests_total)",
          "legendFormat": "total_requests"
        }
      ],
      "gridPos": { "h": 6, "w": 12, "x": 0, "y": 7 }
    },
    {
      "type": "timeseries",
      "title": "Error Rate (%)",
      "id": 5,
      "datasource": "Prometheus",
      "targets": [
        {
          "refId": "A",
          "expr": "100 * sum(rate(http_request_errors_total[1m])) / clamp_min(sum(rate(http_requests_total[1m])), 1)",
          "legendFormat": "error_rate"
        }
      ],
      "fieldConfig": { "defaults": { "unit": "percent" } },
      "gridPos": { "h": 6, "w": 12, "x": 12, "y": 7 }
    },
    {
      "type": "timeseries",
      "title": "Memory Usage (MB)",
      "id": 10,
      "datasource": "Prometheus",
      "targets": [
        {
          "refId": "A",
          "expr": "process_resident_memory_bytes / 1024 / 1024",
          "legendFormat": "memory_mb"
        }
      ],
      "fieldConfig": {
        "defaults": {
          "unit": "MBs",
          "min": 0
        }
      },
      "gridPos": { "h": 6, "w": 12, "x": 0, "y": 12 }
    },
    {
      "type": "gauge",
      "title": "CPU Usage (%)",
      "id": 9,
      "datasource": "Prometheus",
      "targets": [
        {
          "refId": "A",
          "expr": "100 * rate(process_cpu_seconds_total[1m])",
          "legendFormat": "cpu_percent"
        }
      ],
      "fieldConfig": {
        "defaults": {
          "unit": "percent",
          "min": 0,
          "max": 100
        }
      },
      "options": {
        "orientation": "vertical",
        "showThresholdLabels": true,
        "showThresholdMarkers": true
      },
      "gridPos": { "h": 12, "w": 5, "x": 12, "y": 12 }
    }
  ]
}
```

Once added, you can start requesting your Vapor application and see the metrics come to life in Grafana! After a while you might see something like this:

![Grafana Dashboard]( /static/images/posts/otel-integration-grafana-dashboard.png)

## Deployment on AWS

In this section we'll briefly cover how to deploy the monitoring setup on AWS using ECS Fargate. This assumes that there's already an existing Fargate stack with a Vapor service running, possibly defined using a JSON task definition.

### AWS Managed Prometheus

To store the metrics on AWS, we can use [AWS Managed Prometheus](https://aws.amazon.com/prometheus/), which is a fully managed service that makes it easy to monitor and alert on your containerized applications and infrastructure. 
First, we need to create a new Prometheus workspace in the AWS Management Console. A workspace is simply a Prometheus instance we can send data to, tell to scrape data, and query data from.

To create a new workspace, visit https://console.aws.amazon.com/prometheus/home and click on "Create workspace". 
Give it a name (it doesn't need to be unique) and create the workspace. Once created, navigate to the workspace and copy the "Remote write endpoint" URL, which we'll need later.

You can also create it using the AWS CLI:

```bash
aws amp create-workspace --alias <your_workspace_name>
```

### OTel Collector sidecar

Now that we have a Prometheus workspace, we need to set up the OTel Collector as a sidecar in our existing ECS task definition. Adding this to your existing task-definition should do the trick:

```json
{
  "name": "aws-otel-collector",
  "image": "public.ecr.aws/aws-observability/aws-otel-collector:latest",
  "essential": true,
  "secrets": [
    {
      "name": "AOT_CONFIG_CONTENT",
      "valueFrom": "otel-collector-config"
    }
  ],
  "logConfiguration": {
    "logDriver": "awslogs",
    "options": {
      "awslogs-group": "researchrabbit/ecs/api-service-otel-collector",
      "awslogs-region": "{{ region }}",
      "awslogs-stream-prefix": "ecs",
      "awslogs-create-group": "True"
    }
  }
}
```

Just replace the `{{ region }}` placeholder with your AWS region.

Then we need a way to inject the OTel Collector configuration into the sidecar. The recommended way to do this on AWS is via an AWS System Manager parameter. Create a new parameter called `otel-collector-config` with the following content:

```yaml
receivers:
  otlp:
    protocols:
      grpc:
        endpoint: :4317
  awsecscontainermetrics:
    collection_interval: 20s

processors:
  filter:
    metrics:
      include:
        match_type: strict
        metric_names:
          - ecs.task.memory.utilized
          - ecs.task.memory.reserved
          - ecs.task.cpu.utilized
          - ecs.task.cpu.reserved
          - ecs.task.network.rate.rx
          - ecs.task.network.rate.tx
          - ecs.task.storage.read_bytes
          - ecs.task.storage.write_bytes

exporters:
  prometheusremotewrite:
    endpoint: "{{ prometheus_remote_write_endpoint }}"
    auth:
      authenticator: sigv4auth
  debug:
    verbosity: detailed
extensions:
  health_check:
  pprof:
    endpoint: :1888
  zpages:
    endpoint: :55679
  sigv4auth:
    region: {{ region }}

service:
  extensions: [pprof, zpages, health_check, sigv4auth]
  pipelines:
    metrics:
      receivers: [otlp]
      exporters: [debug, prometheusremotewrite]
    metrics/ecs:
      receivers: [awsecscontainermetrics]
      processors: [filter]
      exporters: [debug, prometheusremotewrite]
```

Again, replace the `{{ region }}` and `{{ prometheus_remote_write_endpoint }}` placeholders with your AWS region and the Prometheus remote write endpoint. Make sure the Prometheus endpoint contains the full URL, including the `https://` and `/api/v1/write` parts.

Finally, the ECS task role needs permissions to read the SSM parameter and to write to the Prometheus workspace. Attach the following policy to your ECS task role (or create a new one):

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameter",
      ],
      "Resource": "arn:aws:ssm:{{ region }}:{{ account_id }}:parameter/otel-collector-config"
    },
    {
      "Effect": "Allow",
      "Action": [
          "aps:RemoteWrite"
      ],
      "Resource": "arn:aws:aps:{{ region }}:{{ account_id }}:workspace/{{ workspace_id }}"
    }
  ]
}
```

Replace the `{{ region }}`, `{{ account_id }}`, and `{{ workspace_id }}` placeholders with your AWS region, account ID, and Prometheus workspace ID.

> Note: this is different to the task **execution** role, which is used by ECS to pull the container images. The task role is assumed by the containers themselves.

Now you can deploy the updated task definition to your ECS service. The OTel Collector sidecar will start collecting metrics from your Vapor application and sending them to AWS Managed Prometheus.

### Grafana

For visualizing the metrics, we can use [AWS Managed Grafana](https://aws.amazon.com/grafana/).
Create a new Grafana workspace in the AWS Management Console. Once created, switch to the "Data sources" tab and add a new data source. Select "Prometheus" as the data source type and enable the "AWS Managed Service for Prometheus" option. 

Now you need to give access to your user to the Grafana workspace. This is really simple: on the "Authentication" tab of your Grafana workspace, just add your IAM user or role and assign it the "Admin" role. This will grant you access to add data sources and create dashboards.

Then, navigate to the workspace and set up a data source for Prometheus using the Prometheus workspace we created earlier.

Finally, you can create dashboards in Grafana just like we did in the local setup. If you want to reuse the same dashboard JSON, just import it into your AWS Managed Grafana, but be sure to change the memory and CPU metrics queries to use the AWS ECS metric names:
```promql
ecs_task_memory_utilized
ecs_task_cpu_utilized
```

And there you have it! You've successfully instrumented your Vapor 4 application with OpenTelemetry, set up a monitoring stack using Prometheus and Grafana, and deployed it on AWS using ECS Fargate. Now you can monitor your application's performance and health in real-time. Happy monitoring!
