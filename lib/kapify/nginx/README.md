# kapify/nginx

Capistrano tasks for configuration of nginx web server.

Provides capistrano tasks to:

* easily add application to nginx and reload it's configuration

Provides several capistrano variables for easy customization.
Also, for full customization, all configs can be copied to the application using generators.

## Usage

Add this line to your `deploy.rb`

    require 'kapify/nginx'

Note, that following capistrano variables should be defined:

    application
    current_path
    shared_path
    user

You can check that new tasks are available (`cap -T`):

    # add and enable application to nginx
    cap kapify:nginx:setup

    # reload nginx configuration
    cap kapify:nginx:reload

There is no need to execute any of these tasks manually.
They will be called automatically on different deploy stages:

* `kapify:nginx:setup` and `kapify:nginx:reload` are hooked to `deploy:setup`

This means that if you run `cap deploy:setup`,
nginx will be automatically configured.

However, if you changed variables or customized templates,
you can run any of these tasks to update configuration.

## Customization

### Using variables

You can customize nginx config using capistrano variables:


```ruby
# path to customized templates (see below for details)
# default value: "config/deploy/templates"
set :templates_path, "config/deploy/templates"

# server name for nginx, default value: no (will be prompted if not set)
# set this to your site name as it is visible from outside
# this will allow 1 nginx to serve several sites with different `server_name`
set :nginx_server_name, "example.com"

# if set, nginx will be configured to 443 port and port 80 will be auto rewritten to 443
# also, on `nginx:setup`, paths to ssl certificate and key will be configured
# and certificate file and key will be copied to `/etc/ssl/certs` and `/etc/ssl/private/` directories
# default value: false
set :nginx_use_ssl, false

# remote file name of the certificate, only makes sense if `nginx_use_ssl` is set
# default value: `nginx_server_name + ".crt"`
set :nginx_ssl_certificate, "#{nginx_server_name}.crt"

# remote file name of the certificate, only makes sense if `nginx_use_ssl` is set
# default value: `nginx_server_name + ".key"`
set :nginx_ssl_certificate_key, "#{nginx_server_name}.key"

# local path to file with certificate, only makes sense if `nginx_use_ssl` is set
# this file will be copied to remote server
# default value: none (will be prompted if not set)
set :nginx_ssl_certificate_local_path, "/home/ivalkeen/ssl/myssl.cert"

# local path to file with certificate key, only makes sense if `nginx_use_ssl` is set
# this file will be copied to remote server
# default value: none (will be prompted if not set)
set :nginx_ssl_certificate_key_local_path, "/home/ivalkeen/ssl/myssl.key"
```

For example, of you site name is `example.com`,
your `deploy.rb` will look like this:

```ruby
set :server_name, "example.com"
require 'kapify/nginx'
```

### Template Customization

If you want to change default templates, you can generate them using `rails generator`

    rails g kapify:nginx

This will copy default templates to `config/deploy/templates` directory,
so you can customize them as you like, and capistrano tasks will use this templates instead of default.

You can also provide path, where to generate templates:

    rails g kapify/nginx config/templates
