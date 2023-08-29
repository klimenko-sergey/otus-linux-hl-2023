#!/bin/sh

set -e
set -x

# Installation nginx...
ansible-galaxy install -r environments/lab1/requirements.yml

exit 0