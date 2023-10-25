#!/bin/sh

# set -e
set -x

count=30
while [ "$count" -ne "0" ] ; do
    ping -c 1 ${app_ip} > /dev/null 2>&1
    if [ $? -eq 0 ] ; then
        count=1
        sleep 30
        cd ../../ansible/
        sh ../terraform/scripts/ansible-galaxy_install_roles.sh
        sh ../terraform/scripts/ansible_run_playbooks.sh
        cd -
    else
        echo "Timeout..."
        sleep 1
    fi
    # ((--count))
    # ((count-=1))
    count=$((count-1))
done

exit 0