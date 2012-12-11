# kapify/unicorn

Capistrano tasks for configuration and management unicorn for zero downtime deployments of Rails applications.

Provides capistrano tasks to:

* create unicorn init script for application, so it will be automatically started when OS restarts
* start/stop unicorn (also can be done using `sudo service unicorn_<your_app> start/stop`)
* restart unicorn using `USR2` signal to load new application version with zero downtime

Provides several capistrano variables for easy customization.
Also, for full customization, all configs can be copied to the application using generators.

## Usage

Add this line to your `deploy.rb`

    require 'kapify/unicorn'

Note, that following capistrano variables should be defined:

    application
    current_path
    shared_path
    user

You can check that new tasks are available (`cap -T`):

    # create unicorn configuration and init script
    cap kapify:unicorn:setup

    # start unicorn
    cap kapify:unicorn:start

    # stop unicorn
    cap kapify:unicorn:stop

    # restart unicorn with no downtime
    # old workers will process new request until new master is fully loaded
    # then old workers will be automatically killed and new workers will start processing requests
    cap kapify:unicorn:restart

There is no need to execute any of these tasks manually.
They will be called automatically on different deploy stages:

* `kapify:unicorn:setup` is hooked to `deploy:setup`
* `kapify:unicorn:restart` is hooked to `deploy:restart`

This means that if you run `cap deploy:setup`,
unicorn will be automatically configured.
And after each deploy, unicorn will be automatically restarted.

However, if you changed variables or customized templates,
you can run any of these tasks to update configuration.

## Customization

### Using variables

You can customize unicorn configs using capistrano variables:


```ruby
# path to customized templates (see below for details)
# default value: "config/deploy/templates"
set :templates_path, "config/deploy/templates"

# path, where unicorn pid file will be stored
# default value: `"#{current_path}/tmp/pids/unicorn.pid"`
set :unicorn_pid, "#{current_path}/tmp/pids/unicorn.pid"

# path, where unicorn config file will be stored
# default value: `"#{shared_path}/config/unicorn.rb"`
set :unicorn_config, "#{shared_path}/config/unicorn.rb"

# path, where unicorn log file will be stored
# default value: `"#{shared_path}/config/unicorn.rb"`
set :unicorn_log, "#{shared_path}/config/unicorn.rb"

# user name to run unicorn
# default value: `user` (user varibale defined in your `deploy.rb`)
set :unicorn_user, "user"

# number of unicorn workers
# default value: no (will be prompted if not set)
set :unicorn_workers, 4

```

For example, if you want to use 8 unicorn workers,
your `deploy.rb` will look like this:

```ruby
set :unicorn_workers, 8
require 'kapify/unicorn'
```

### Template Customization

If you want to change default templates, you can generate them using `rails generator`

    rails g kapify:unicorn

This will copy default templates to `config/deploy/templates` directory,
so you can customize them as you like, and capistrano tasks will use this templates instead of default.

You can also provide path, where to generate templates:

    rails g kapify:unicorn config/templates
