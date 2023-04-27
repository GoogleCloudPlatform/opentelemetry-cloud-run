# Terraform example

This example deploys a single-container service
([`basic-service.yaml`](basic-service.yaml)) and uses Terraform to apply the
multi-container sidecar Collector to it.

## Running the example

First, follow the steps from the [main README](../README.md#getting-started) to:

1. [Build the sample app](../README.md#build-the-sample-app)
2. [Build the Collector image](../README.md#build-the-collector-image)

Next, replace the `%GCP_PROJECT%` placeholder in
[`basic-service.yaml`](basic-service.yaml) and [`main.tf`](main.tf) with your
GCP project ID:

```
export GCP_PROJECT=<your project>
sed -i s@%GCP_PROJECT%@${GCP_PROJECT}@g basic-service.yaml
sed -i s@%GCP_PROJECT%@${GCP_PROJECT}@g main.tf
```

Deploy the basic Service:

```
gcloud run services replace basic-service.yaml
```

Save the Service URL from this command.

You should now be able to see the Service is deployed, but there is no telemetry
data exported to GCP.

Modify the service using Terraform with the following commands:

```
terraform init
terraform apply
```

When prompted by `terraform apply`, enter `yes` to confirm the changes.

Use `curl` to hit the Service endpoint a few times and you will start to see
telemetry data flowing in (just like in the [main README guide](../README.md#view-telemetry-in-google-cloud)).
