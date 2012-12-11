# kapify/pg

Capistrano tasks for basic configuration and management of Resque.

Provides capistrano tasks to:

* create resque init script for application, so it will be automatically started when OS restarts
* start/stop resque (also can be done using `sudo service resque_<your_app> start/stop`)
* gracefully restart resque on deployment

Provides several capistrano variables for easy customization.
Also, for full customization, init script's config can be copied to the application using generators.

## Usage

Add this line to your `deploy.rb`

    require 'kapify/resque'

Next, add role `resque_worker` to the server which you want resque workers to be started on.

Note, that following capistrano variables should be defined:

    application
    current_path
    shared_path
    user

You can check that new tasks are available (`cap -T`):

    # create resque configuration and init script
    cap kapify:resque:setup

    # start resque
    cap kapify:resque:start

    # stop resque
    cap kapify:resque:stop

    # gracefully restart resque
    cap kapify:resque:restart

There is no need to execute any of these tasks manually.
They will be called automatically on different deploy stages:

* `kapify:resque:setup` is hooked to `deploy:setup`
* `kapify:resque:restart` is hooked to `deploy:restart`

This means that if you run `cap deploy:setup`,
resque will be automatically configured.
And after each deploy, resque will be automatically reloaded.

However, if you changed variables or customized templates,
you can run any of these tasks to update configuration.

## Customization

### Using variables

You can customize resque configs using capistrano variables:

```ruby
# user name to run resque
# default value: `user` (user varibale defined in your `deploy.rb`)
set :resque_user, "user"

# number of resque workers
# default value: 2
set :resque_workers, 4

# name of resque workers queue
# default value: *
set :resque_queue, "*"

# path to the bundle command
# default value: /usr/local/rbenv/shims/bundle (for globally installed rbenv)
set :resque_bundle, "/usr/bin/bundle"

# name of rake task to run resque worker
# default value: "environment resque:work"
set :resque_task, "resque:work"

```

For example, if you don't want to load environment for your workers,
your `deploy.rb` will look like this:

```ruby
set :resque_task, "resque:work"
require 'kapify/resque'
```

### Template Customization

If you want to change default templates, you can generate them using `rails generator`

    rails g kapify:resque

This will copy default templates to `config/deploy/templates` directory,
so you can customize them as you like, and capistrano tasks will use this templates instead of default.

You can also provide path, where to generate templates:

    rails g kapify:resque config/templates
