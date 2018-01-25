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
* `WEBROOT` - The webroot where drush commands will be executed (usually `/app/web`)
* `S3_BUCKET` - The S3 bucket name where backups will be stored
* `AWS_ACCESS_KEY_ID` - The AWS access key ID to authenticate
* `AWS_SECRET_ACCESS_KEY` - The AWS secret access key to authenticate
* `S3_BACKUP_FILESYSTEM_ENABLED` - 1 (on) or 0 (off)
* `S3_BACKUP_DATABASE_ENABLED` - 1 (on) or 0 (off)

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