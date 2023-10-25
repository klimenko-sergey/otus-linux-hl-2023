#!/bin/sh

set -e
set -x

# Installation nginx...
ansible-galaxy install -r environments/lab2/requirements.yml

exit 0