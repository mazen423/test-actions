#!/bin/bash

# Example values for demonstration purposes
BRANCH_NAME="master"
DEPLOYMENT_REGION=${DEPLOYMENT_REGION:-"both"}
APP_FOLDER=("europe-west4" "europe-west1")

echo "BRANCH_NAME is: $BRANCH_NAME"
echo "DEPLOYMENT_REGION is: $DEPLOYMENT_REGION"

if [[ "$DEPLOYMENT_REGION" == "europe-west4" ]]; then
  APP_FOLDER=("apps/europe-west4")
  echo "Condition met, APP_FOLDER set to: ${APP_FOLDER[@]}"
else
  echo "Condition not met."
fi
