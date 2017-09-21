# Nanotube

It's a nano-youtube, based on `ffmpeg` and `sqlite3`.

## Install

The installation process is pretty painful, because I really wanted to try https://github.com/Austinb/nginx-upload-module.git.

So first you need to recompile Nginx with this module:

```
# on Debian/Ubuntu

apt-get update && apt-get upgrade

git clone https://github.com/Austinb/nginx-upload-module.git /root/nginx-upload-module

sudo apt-get install software-properties-common python-software-properties
sudo apt-get install dpkg-dev git

apt-get source nginx
sudo apt-get build-dep nginx

## ADD to /root/nginx-[version]/debian/rules under extras_configure_flags
--add-module=/root/nginx-upload-module
#

cd /root/nginx-1.12.1 && dpkg-buildpackage -b
dpkg --install nginx-full_[version]_amd64.deb nginx-common_[version]_all.deb libnginx-mod-*
```

Sample Nginx configuration:

```
server {
  listen 80;
  server_name nanotube.phorque.it;
  server_tokens off;
  root /nowhere;
  rewrite ^ https://nanotube.phorque.it$request_uri permanent;
}
	  

server {
    client_max_body_size 900m;
    listen       443;

    server_tokens off;

    ssl on;
    ssl_certificate /etc/letsencrypt/live/nanotube.phorque.it/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/nanotube.phorque.it/privkey.pem;
		     

    root /home/app/app/public;
    try_files $uri/index.html $uri @app;

    # Upload form should be submitted to this location
    location /upload {
        # Pass altered request body to this location
        upload_pass   @app;

        # Store files to this directory
        # The directory is hashed, subdirectories 0 1 2 3 4 5 6 7 8 9 should exist
        upload_store /var/www/html/upload 1;

        # Allow uploaded files to be read only by user
        upload_store_access all:rw;

        # Set specified fields in request body
        upload_set_form_field $upload_field_name.name "$upload_file_name";
        upload_set_form_field $upload_field_name.content_type "$upload_content_type";
        upload_set_form_field $upload_field_name.path "$upload_tmp_path";

        # Inform backend about hash and size of a file
        upload_aggregate_form_field "$upload_field_name.md5" "$upload_file_md5";
        upload_aggregate_form_field "$upload_field_name.size" "$upload_file_size";

        upload_pass_form_field "^submit$|^title|^description$";

        upload_cleanup 400 404 499 500-505;
    }

    # Pass altered request body to a backend
    location @app {
        proxy_pass   http://localhost:8080;
	proxy_redirect off;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
	proxy_set_header Host $http_host;
	proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

Then you need to create a few directories for `nginx-upload-module` to work:

```
mkdir /var/www/upload
cd /var/www/upload && mkdir 0 1 2 3 4 5 6 7 8 9 && chown -R www-data:www-data ../upload
```

And Nanotube has the few usual dependencies:

```
sudo apt-get install ffmpeg imagemagick libmagickwand-dev libsqlite3-dev
```
