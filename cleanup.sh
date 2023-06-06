#!/bin/bash
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

set -ex

PROJECT_ID=$(gcloud config get-value project)
SA_NAME="run-otel-example-sa"
REGION="us-east1"

#### Delete Cloud Run service
gcloud run services delete opentelemetry-cloud-run-sample --region "${REGION}" --quiet

#### Delete Artifact Registry
gcloud artifacts repositories delete run-otel-example \
  --location="${REGION}" \
  --quiet

#### Delete the servcie account used for Cloud Build
gcloud iam service-accounts delete "${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" --quiet
