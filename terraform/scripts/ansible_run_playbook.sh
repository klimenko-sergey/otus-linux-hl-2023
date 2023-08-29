#!/bin/sh

set -e
set -x

# Run playbook...
ansible-playbook playbooks/nginx-app.yml

exit 0