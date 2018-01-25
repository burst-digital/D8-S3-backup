#!/bin/bash

# Check required env vars
source `dirname $BASH_SOURCE`/../init.sh

# Check for required env vars
check_env_variables WEBROOT S3_BUCKET AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY PLATFORM_BRANCH PLATFORM_ENVIRONMENT S3_BACKUP_DATABASE_ENABLED S3_BACKUP_FILESYSTEM_ENABLED

now=$(date +"%Y%m%d_%H%M")

# Go into webroot to use drush
cd ${WEBROOT}

# Create sites array based on aliases for this branch
sites=($(drush sa | grep -v -E '@|default|sites|none|self|root|uri'))

# If not multisite
if [ ${#sites[@]} < 1 ] ; then
  sites=(${WEBROOT})
fi

# Multisite
for site in "${sites[@]}"
do
  echo
  echo ">>> $site"
  aws s3 ls "s3://$S3_BUCKET/$site/$PLATFORM_BRANCH/database"
done
