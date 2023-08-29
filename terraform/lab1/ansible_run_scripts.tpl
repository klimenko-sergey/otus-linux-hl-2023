#!/bin/sh

# set -e
set -x

count=30
while [ "$count" -ne "0" ] ; do
    ping -c 1 ${app_ip} > /dev/null 2>&1
    if [ $? -eq 0 ] ; then
        count=1
        cd ../../ansible/
        sh ../terraform/scripts/ansible_install_jdauphant_nginx.sh
        sh ../terraform/scripts/ansible_run_playbook.sh
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