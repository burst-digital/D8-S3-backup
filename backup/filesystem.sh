#!/bin/bash

# Check required env vars
source `dirname $BASH_SOURCE`/../init.sh

# Check for required env vars
check_env_variables WEBROOT S3_BUCKET AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY PLATFORM_BRANCH PLATFORM_ENVIRONMENT S3_BACKUP_FILESYSTEM_ENABLED

if [ "$S3_BACKUP_FILESYSTEM_ENABLED" = "1" ] ; then

  # Go into webroot to use drush
  cd ${WEBROOT}

  # Create sites array based on aliases for this branch
  sites=($(drush sa | grep -v -E '@|default|sites|none|self|root|uri'))

  # If not multisite
  if [ ${#sites[@]} -eq 0 ] ; then
    sites=("default")
  fi

  # Multisite
  for site in "${sites[@]}"
  do
    files_dir="$WEBROOT/sites/$site/files/"
    destination_dir="s3://$S3_BUCKET/$site/$PLATFORM_BRANCH/files/"

    echo
    echo ">>> Starting file backup for $site"

    echo
    echo ">>> Starting upload to S3"
    aws s3 sync ${files_dir} ${destination_dir}

    echo
    echo ">>> Files uploaded to $destination_dir"

    echo
    echo ">>> Completed file backup for $site"
  done
else
  echo "S3 database backups are disabled. To enable change the variable 'S3_BACKUP_FILESYSTEM_ENABLED' to '1'"
fi