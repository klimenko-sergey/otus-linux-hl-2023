#!/bin/sh

set -e
set -x

# Run playbook...
ansible-playbook playbooks/site.yml

exit 0