#!/bin/bash

# Python PIP
if which pip > /dev/null
then
  echo
  echo ">>> Python pip is already installed, skipping..."
else
  echo
  echo ">>> Install Python pip"
  (
    apt-get install python-pip -y
  )
fi

# AWS CLI
echo
echo ">>> Install AWS CLI tool"
pip install awscli
