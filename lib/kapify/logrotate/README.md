# kapify/logrotate

Capistrano task for enabling log rotation for your Rails application

Provides capistrano tasks to:

* creates logrotate record to rotate application logs

For full customization, config can be copied to the application using generator.

## Usage

Add this line to your `deploy.rb`

    require 'kapify/logrotate'

Note, that following capistrano variables should be defined:

    shared_path
    user

You can check that new tasks are available (`cap -T`):

    # create logrotate record to rotate application logs
    cap logrotate

There is no need to execute any of these tasks manually.
They will be called automatically on different deploy stages:

* `logrotate` is hooked to `deploy:setup`

This means that if you run `cap deploy:setup`,
logrotate will be automatically set up.

## Template Customization

If you want to change default template, you can generate them using `rails generator`

    rails g kapify:logrotate

This will copy default templates to `config/deploy/templates` directory,
so you can customize them as you like, and capistrano tasks will use this templates instead of default.

You can also provide path, where to generate templates:

    rails g kapify:logrotate config/templates

For example, if you also use nginx and unicorn, you want to notify them about rotation.
In this case, your template file could look like this:

```erb
<%= shared_path %>/log/*.log {
  daily
  missingok
  rotate 180
  compress
  dateext
  delaycompress

  lastaction
    pid=<%= unicorn_pid %>
    test -s $pid && kill -USR1 "$(cat $pid)"
  endscript

  prerotate
    if [ -d /etc/logrotate.d/httpd-prerotate ]; then \
      run-parts /etc/logrotate.d/httpd-prerotate; \
    fi \
  endscript

  postrotate
    [ ! -f /run/nginx.pid ] || kill -USR1 `cat /run/nginx.pid`
  endscript
}
```
