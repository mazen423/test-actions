#! /bin/bash
set -eu -o pipefail

GITOPS_BRANCH=""
DEPLOYMENT_NAME=""
DEPLOYMENT_NAMESPACE=""
DEPLOYMENT_SECRET_NAME=""
DEPLOYMENT_GCP_PROJECT="mms-web-webmobile-mreg-d-v002"
TERRAFORM_BRANCH=""
UPDATE_LOADBALANCING="false" # Only required for apps on feature branches that shall be deployed
UPDATE_KUSTOMIZATION="false" # Only required feature branches that shall be deployed
#APP_FOLDER="apps/common" # App deployments go to the common folder, cron jobs should be deployed only on one cluster
DEPLOYMENT_REGION="both"
APP_FOLDER=("apps/europe-west4", "apps/europe-west1")
MAX_LENGTH_APP_NAME=52 # Limited by DNS specification and Helm chart schema

if [[ "$DEPLOYMENT_TYPE" == "cronjob" ]]; then
  APP_FOLDER=("apps/europe-west4")
fi

if [ "$BRANCH_NAME" == "master" ] && [ "$DEPLOYMENT_REGION" == "europe-west4" ]; then
  APP_FOLDER=("apps/europe-west4")
fi

if [ "$BRANCH_NAME" == "master" ] && [ "$DEPLOYMENT_REGION" == "europe-west1" ]; then
  APP_FOLDER=("apps/europe-west1")
fi

if [ "$BRANCH_NAME" == "master" ] && [ "$DEPLOYMENT_REGION" == "europe-west4" ]; then
  APP_FOLDER="apps/europe-west4"
fi

if [ "$BRANCH_NAME" == "master" ] && [ "$PRODUCTION_DEPLOYMENT" == "true" ]; then
  GITOPS_BRANCH="prod"
  TERRAFORM_BRANCH="master"
  DEPLOYMENT_NAME="${APP_NAME}"
  DEPLOYMENT_NAMESPACE="prod"
  DEPLOYMENT_SECRET_NAME="${APP_NAME}-prod"
  DEPLOYMENT_GCP_PROJECT="mms-web-webmobile-mreg-p-v002"
elif [ "$BRANCH_NAME" == "master" ]; then
  GITOPS_BRANCH="prod"
  TERRAFORM_BRANCH="master"
  DEPLOYMENT_NAME="${APP_NAME}"
  DEPLOYMENT_NAMESPACE="prelive"
  DEPLOYMENT_SECRET_NAME="${APP_NAME}-prelive"
  DEPLOYMENT_GCP_PROJECT="mms-web-webmobile-mreg-p-v002"
elif [ "$BRANCH_NAME" == "qa" ]; then
  GITOPS_BRANCH="dev"
  TERRAFORM_BRANCH="dev"
  DEPLOYMENT_NAME="${APP_NAME}"
  DEPLOYMENT_NAMESPACE="qa"
  DEPLOYMENT_SECRET_NAME="${APP_NAME}-qa"
elif [ "$BRANCH_NAME" == "develop" ]; then
  GITOPS_BRANCH="dev"
  TERRAFORM_BRANCH="dev"
  DEPLOYMENT_NAME="${APP_NAME}"
  DEPLOYMENT_NAMESPACE="dev"
  DEPLOYMENT_SECRET_NAME="${APP_NAME}-dev"
elif [ "$BRANCH_NAME" == "playground" ]; then # Can be removed after testing flux v2 upgrade
  DEPLOYMENT_GCP_PROJECT="mms-web-webmobile-mreg-a-v001"
  GITOPS_BRANCH="playground_v2"
  TERRAFORM_BRANCH="dev"
  DEPLOYMENT_NAME="${APP_NAME}"
  DEPLOYMENT_NAMESPACE="playground"
  DEPLOYMENT_SECRET_NAME="${APP_NAME}-playground"
  UPDATE_LOADBALANCING="false"
  UPDATE_KUSTOMIZATION="true"
fi




echo "DEPLOYMENT_NAME=${DEPLOYMENT_NAME}" >> $GITHUB_OUTPUT
echo "GITOPS_BRANCH=${GITOPS_BRANCH}" >> $GITHUB_OUTPUT
echo "DEPLOYMENT_NAMESPACE=${DEPLOYMENT_NAMESPACE}" >> $GITHUB_OUTPUT
echo "DEPLOYMENT_SECRET_NAME=${DEPLOYMENT_SECRET_NAME}" >> $GITHUB_OUTPUT
echo "TERRAFORM_BRANCH=${TERRAFORM_BRANCH}" >> $GITHUB_OUTPUT
echo "UPDATE_LOADBALANCING=${UPDATE_LOADBALANCING}" >> $GITHUB_OUTPUT
echo "DEPLOYMENT_GCP_PROJECT=${DEPLOYMENT_GCP_PROJECT}" >> $GITHUB_OUTPUT
echo "UPDATE_KUSTOMIZATION=${UPDATE_KUSTOMIZATION}" >> $GITHUB_OUTPUT
echo "APP_FOLDER=${APP_FOLDER}" >> $GITHUB_OUTPUT

# Export as environment variables so they can directly used by follow up bash scripts
{
  echo "DEPLOYMENT_NAME=${DEPLOYMENT_NAME}";
  echo "GITOPS_BRANCH=${GITOPS_BRANCH}";
  echo "DEPLOYMENT_NAMESPACE=${DEPLOYMENT_NAMESPACE}";
  echo "DEPLOYMENT_SECRET_NAME=${DEPLOYMENT_SECRET_NAME}";
  echo "TERRAFORM_BRANCH=${TERRAFORM_BRANCH}";
  echo "UPDATE_LOADBALANCING=${UPDATE_LOADBALANCING}";
  echo "DEPLOYMENT_GCP_PROJECT=${DEPLOYMENT_GCP_PROJECT}";
  echo "UPDATE_KUSTOMIZATION=${UPDATE_KUSTOMIZATION}";
  echo "APP_FOLDER=${APP_FOLDER}";
} >> "$GITHUB_ENV"

echo "Deploying with following config:"
cat "$GITHUB_ENV"
