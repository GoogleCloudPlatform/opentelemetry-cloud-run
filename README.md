# Deploying a Cloud Run Service with OpenTelemetry Instrumentation

This repository contains langauge-specific guides showing how to run the OpenTelemetry
Collector to collect metrics, traces, and logs in a Cloud Run deployment. This uses the **Cloud Run
multicontainer (sidecar) feature** to run the Collector as a sidecar container
alongside your workload container.

[Learn more about sidecars in Cloud Run here.](https://cloud.google.com/run/docs/deploying#sidecars)

The repository contains guides for the following languages/frameworks:
1. [Golang](./golang/README.md)
2. [C# (.NET)](./csharp/README.md)
