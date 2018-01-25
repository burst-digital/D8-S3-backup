#!/bin/bash

/bin/bash `dirname $BASH_SOURCE`/backup/filesystem.sh
/bin/bash `dirname $BASH_SOURCE`/backup/database.sh