#!/bin/bash

# Check required env vars
source `dirname $BASH_SOURCE`/../init.sh

# Check for required env vars
check_env_variables WEBROOT S3_BUCKET AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY PLATFORM_BRANCH PLATFORM_ENVIRONMENT S3_BACKUP_DATABASE_ENABLED S3_BACKUP_FILESYSTEM_ENABLED

now=$(date +"%Y-%m-%d")

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
  backups=(`aws s3 ls "$S3_BUCKET/$site/$PLATFORM_BRANCH/database/" | awk '{$1=$2=$3=""; print $0}' | sed 's/^[ \t]*//' | sed 's#.sql.gz$##'`)

  echo
  echo ">>> $site"

  for backup in "${backups[@]}"
  do
    echo "$backup"
    year=${backup:0:4}
    month=${backup:4:2}
    day=${backup:6:2}

    diff_day=$(( ($(date -d "$now" +%s) - $(date -d "$year-$month-$day" +%s)) / (60*60*24) ))

    if [ ${diff_day} -gt 30 ] ; then
      if [ ${day} -ne 01 ] && [ ${day} -ne 11 ] && [ ${day} -ne 21 ]; then
        echo "Backup is $diff_day days old... deleting."
        aws s3 rm "s3://$S3_BUCKET/$site/$PLATFORM_BRANCH/database/$backup.sql.gz"
      else
        echo "Backup is from the ${day}st day of the month... keeping."
      fi
    else
      echo "Backup is $diff_day days old... keeping."
    fi
  done
done