nginx_configs:
  upstream:
    - upstream backend {
        server ${backend_ip-0}:80 weight=1 max_fails=2 fail_timeout=3;
        server ${backend_ip-1}:80 weight=1 max_fails=2 fail_timeout=3;
      }
    - upstream phpfcgi {
        server ${backend_ip-0}:9000 weight=1 max_fails=2 fail_timeout=3;
        server ${backend_ip-1}:9000 weight=1 max_fails=2 fail_timeout=3;
      }
nginx_sites:
  server:
    - listen 80
    - server_name localhost
    - location / {
        proxy_pass http://backend;
      }
    - location ~ \.php$ {
        root /var/www/html;
        include /etc/nginx/fastcgi_params;
        fastcgi_read_timeout 3600s;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_pass phpfcgi;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_index index.php;
      }