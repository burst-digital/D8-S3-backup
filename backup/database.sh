#!/bin/bash

# Check required env vars
source `dirname $BASH_SOURCE`/../init.sh

# Check for required env vars
check_env_variables WEBROOT S3_BUCKET AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY PLATFORM_BRANCH PLATFORM_ENVIRONMENT S3_BACKUP_DATABASE_ENABLED

if [ "$S3_BACKUP_DATABASE_ENABLED" = "1" ] ; then

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
    datetime=$(date +"%Y%m%d_%H%M")
    mkdir -p /app/drush-backups/${site}/${PLATFORM_BRANCH}
    file="/app/drush-backups/$site/$PLATFORM_BRANCH/$datetime.sql"

    cd ${WEBROOT}/sites/${site}

    echo
    echo ">>> Starting database dump for $site"
    drush sql-dump --gzip --result-file=${file}

    # Add ".gz" to filename, drush automatically adds this when saving the file
    file="$file.gz"

    # S3 file destination
    destination_file="s3://$S3_BUCKET/$site/$PLATFORM_BRANCH/database/$datetime.sql.gz"

    echo
    echo ">>> Database dumped to $file"

    echo
    echo ">>> Starting upload to S3"
    aws s3 cp ${file} ${destination_file}

    echo
    echo ">>> Database dump uploaded to $destination_file"

    echo
    echo ">>> Removing local database dump"
    rm -rf ${file}

    echo
    echo ">>> Completed database dump for $site"
  done
else
  echo "S3 database backups are disabled. To enable change the variable 'S3_BACKUP_DATABASE_ENABLED' to '1'"
fi