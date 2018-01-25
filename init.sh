#!/bin/bash

# Check if ENV vars are set and not empty
# Usage: $ check_env_variables APP_ROOT WEBROOT
function check_env_variables() {
  for var in "$@"; do
    if [ -z "${!var}" ]; then
      echo "Required environment variable '$var' not set or empty"
      exit 1;
    fi
  done
}
