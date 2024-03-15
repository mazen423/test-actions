#! /bin/bash
set -eu -o pipefail

DEPLOYMENT_TYPE="ss"
DEPLOYMENT_NAME="try1"
APP_FOLDER=("apps/region1" "apps/region2")
DEPLOYMENT_LOCATION=("region1")

if [[ "$DEPLOYMENT_TYPE" == "cronjob" ]]; then
  APP_FOLDER=("apps/region1")
fi

if [[ "$DEPLOYMENT_LOCATION" == "region1" ]]; then
  APP_FOLDER=("apps/region1")
fi

if [[ "$DEPLOYMENT_LOCATION" == "region2" ]]; then
  APP_FOLDER=("apps/region2")
fi

echo ${APP_FOLDER[@]}
echo "APP_FOLDER=${APP_FOLDER[@]}" >> $GITHUB_OUTPUT
echo "DEPLOYMENT_NAME=${DEPLOYMENT_NAME}" >> $GITHUB_OUTPUT

# Export as environment variables so they can directly used by follow up bash scripts
{
  echo "APP_FOLDER=${APP_FOLDER[@]}";
  echo "DEPLOYMENT_NAME=${DEPLOYMENT_NAME}";

} >> "$GITHUB_ENV"

echo "Deploying with following config:"
cat "$GITHUB_ENV"
