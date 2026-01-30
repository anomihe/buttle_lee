#!/bin/bash
set -e

PROJECT_ID="gen-lang-client-0412132796"
IMAGE="gcr.io/$PROJECT_ID/my_butler_server:latest"
INSTANCE_GROUP="serverpod-production-group"
ZONE="us-central1-a"

echo "Submitting build to Cloud Build..."
gcloud builds submit --tag $IMAGE . --project=$PROJECT_ID

echo "Restarting instance group to pull new image..."
gcloud compute instance-groups managed rolling-action restart $INSTANCE_GROUP \
    --project=$PROJECT_ID \
    --zone=$ZONE

echo "Deployment triggered! Instances are restarting."
