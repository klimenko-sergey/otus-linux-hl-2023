[nginx]
${app_name} ansible_host=${app_ip}

[db]
${db_name} ansible_host=${db_ip}

[backend]
${backend_name-0} ansible_host=${backend_ip-0}
${backend_name-1} ansible_host=${backend_ip-1}

[db:vars]
ansible_ssh_common_args='-o ProxyCommand="ssh -i ~/.ssh/yakey -A -W %h:%p -q debian@${app_ip}"'

[backend:vars]
ansible_ssh_common_args='-o ProxyCommand="ssh -i ~/.ssh/yakey -A -W %h:%p -q debian@${app_ip}"'