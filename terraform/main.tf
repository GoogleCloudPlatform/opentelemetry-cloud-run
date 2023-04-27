# Copyright 2023 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

provider "google" {
  project = "%GCP_PROJECT%"
}

resource "google_cloud_run_v2_service" "default" {
  name     = "opentelemetry-cloud-run-terraform"
  location = "us-central1"
  launch_stage = "ALPHA"

  template {
    annotations = {
      "run.googleapis.com/client-name" = "terraform"
      "run.googleapis.com/container-dependencies" = "{'app':['collector']}"
    }
    containers {
      name = "app"
      image = "us-east1-docker.pkg.dev/%GCP_PROJECT%/run-otel-example/sample-app"
      ports {
        container_port = "8080"
      }
    }
    containers {
      name = "collector"
      image = "us-east1-docker.pkg.dev/%GCP_PROJECT%/run-otel-example/collector"
      startup_probe {
        http_get {
          port = "13133"
        }
      }
      volume_mounts {
        name = "shared-logs"
        mount_path = "/logging"
      }
    }
  }
}
