# Drupal 8 AWS S3 backup ~~& restore~~
This repository can be installed into every Drupal 8 project that runs on platform.sh. It automatically backups the filesystem and databases every night ~~and enables you to restore the filesystem or databases with a single command~~.

## Installation
Clone this repository into `<project_root>/bin`.

### AWS S3
__TODO:__
* Create user
* Create policy
* Create bucket
* Enable object versioning
* Look up AWS credentials

### Setup
1. Create a bucket on [aws](https://s3.console.aws.amazon.com/s3/home?region=us-east-1#).
2. Bucket name: name of the platform
2. Region: EU (London)
2. Click on 'Next'
2. Enable versioning property --> click on versioning --> enable versioning
2. Click on 'Next'
2. Click on 'Next'
2. Click on 'Create bucket'
1. You have created a bucket, now create a user for this bucket on [IAM](https://console.aws.amazon.com/iam/home?region=us-east-1#/users).
1. Click on 'add user'
3. User name: The name of the bucket + -drupal
3. Enable the checkbox 'Programmatic access'
3. Click on 'Next: Permissions'
3. Click on the block 'Attach existing policies directly'
3. Click on 'Create policy'
4. You are now createing a policy
4. Click on 'Choose a service' --> Searh for S3 --> click on S3
4. Click on 'Select actions' --> enable the checkbox 'All S3 actions'
4. Click on 'Resources' --> Click on 'add ARN' under the bucket tab --> add the name for the bucket in 'Bucket name' --> Click on 'Save changes' --> Enable the checkbox 'Any' under the object tab.
4. You are done with the policy --> Click on 'Review policy'
4. Name: the name of the bucket, leave description empty
4. Click on 'Create policy'
4. You have created a policy, you can close this internet tab.
3. Click on 'Refresh'
3. Search for the name of the policy (Bucket name)
3. Enable the checkbox left of the policy you want to add
3. Click on 'Next: Review'
3. Click on 'Create user'
3. Congratulations, you have created a User. Copy the access key and the secret access key, you need these key to set the environment variables.

### Platform.app.yaml
You need to add some configuration in `<project_root>/platform.app.yml` to install and periodically run the scripts.

#### Crons
```
crons:
  backup:
    spec: '0 4 * * *'
    cmd: '/bin/bash -e bin/S3/backup.sh'
```
_Note: You can edit `spec` to manage at what time the backups run. The example above runs every night at 04:00._

#### Hooks
```
hooks:
  build: /bin/bash -e bin/S3/install.sh
```

### ENV vars
The following ENV vars need to be added to platform.sh:
* `env:WEBROOT` - The webroot where drush commands will be executed (usually `/app/web`)
* `env:S3_BUCKET` - The S3 bucket name where backups will be stored
* `env:AWS_ACCESS_KEY_ID` - The AWS access key ID to authenticate
* `env:AWS_SECRET_ACCESS_KEY` - The AWS secret access key to authenticate
* `env:S3_BACKUP_FILESYSTEM_ENABLED` - 1 (on) or 0 (off)
* `env:S3_BACKUP_DATABASE_ENABLED` - 1 (on) or 0 (off)

## Usage

### Backup
Backups are automatically made every night.
Database backups are stored by datetime in the filename.
File backups are managed by AWS S3 bucket versioning.

#### TODO: ~~Manual backup~~
* Manually backup the filesystem: `command`.
* Manually backup all databases: `command`. To backup the database of only one site, add the flag `--site=<sitename_here>`

### TODO: ~~Restore~~
* Restore filesystem: `command`.
* Restore all databases: `command`. To restore the database of only one site, add the flag `--site=<sitename_here>`