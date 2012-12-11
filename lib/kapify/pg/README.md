# kapify/pg

Capistrano tasks for basic configuration and management of PostgreSQL database.

Provides capistrano tasks to:

* create database.yml in `shared` folder and symlink into `config`
* create user and database in postgres

Provides several capistrano variables for easy customization.
Also, for full customization, template of `database.yml` file can be copied to
the application using generator.

## Usage

Add this line to your `deploy.rb`

    require 'kapify/pg'

Next, add role `pg` to the server which has running instance of PostgreSQL.
Address of this server will be automatically used as `pg_host` (see below),
`create_user` and `create_database` tasks will be executed on this server:

```ruby
# for dedicated database server it could look like this:
server "192.168.33.12", :db, :pg, no_release: true

# for all-in-one server it could look like this:
server "192.168.33.11", :web, :app, :db, :pg, primary: true
```

Note, that following capistrano variables should be defined in the `deploy.rb` file:

    application
    current_path
    shared_path
    user

You can check that new tasks are available (`cap -T`):

    # create database user for the application
    cap kapify:pg:create_user

    # create database for the application
    cap kapify:pg:create_database

    # generates `database.yml` file in the `shared/config` folder
    cap kapify:pg:setup

    # symlinks `database.yml` from the `shared/config` folder to `current/config` folder
    cap kapify:pg:symlink

There is no need to execute any of these tasks manually.
They will be called automatically on different deploy stages:

* `kapify:pg:create_user`, `kapify:pg:create_database` and `kapify:pg:setup` are hooked to `deploy:setup`
* `kapify:pg:symlink` is hooked to `deploy:finalize_update`

This means that if you run `cap deploy:setup`,
user and database will be created and `database.yml` file will be generated.
And on each deploy, `database.yml` will be automatically linked to current version.

However, if you changed variables or customized templates,
you can run any of these tasks to update configuration.

## Customization

### Using variables

You can customize `database.yml` using capistrano variables:

```ruby
# path to customized templates (see below for details)
# default value: "config/deploy/templates"
set :templates_path, "config/deploy/templates"

# `host` value in `database.yml`
# default value: address of the server, marked with `pg` role
set :pg_host, "localhost"

# `port` value in `database.yml`
# default value: 5432
set :pg_port, "5432"

# `database` value in `database.yml`
# default value: application variable value
set :pg_database, "myapp_production"

# `pool` value in `database.yml`
# default value: 5
set :pg_pool, "5"

# `username` value in `database.yml`
# default value: application variable value
set :pg_user, application

# `password` value in `database.yml`
# default value: will be asked if not set
# setting this value in config file is not recommended
set :pg_password, application

# indicates, it new database should be created on `deploy:setup` or not
# default value: true
set :pg_create_db, true
```

### Template Customization

If you want to change default template, you can generate it using `rails generator`

    rails g kapify:pg

This will copy default template to `config/deploy/templates` directory,
so you can customize them as you like, and capistrano tasks will use this templates instead of default.

You can also provide path, where to generate template:

    rails g kapify:pg config/templates
