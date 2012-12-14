# Kapify

Provides several useful capistrano recipes, that can be used for deployment of Ruby on Rails applications with rbenv.

* [Logrotate](https://github.com/ivalkeen/kapify/tree/master/lib/kapify/logrotate)
    + set up logs rotation
* [Nginx](https://github.com/ivalkeen/kapify/tree/master/lib/kapify/nginx)
    + config site
    + reload
* [PostgreSQL](https://github.com/ivalkeen/kapify/tree/master/lib/kapify/pg)
    + link database.yml from template
    + create pg user for application
* [Resque](https://github.com/ivalkeen/kapify/tree/master/lib/kapify/resque)
    + create and register init script
    + start/stop/restart using init script
* [Unicorn](https://github.com/ivalkeen/kapify/tree/master/lib/kapify/unicorn)
  (with zero downtime deployments with nginx)
    + create and register init script
    + start/stop/restart using init script

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kapify', group: :development, require: false
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kapify

## Usage

Require each recipe in `deploy.rb` file.
All recipes could be customized using variables.
Also there are template generators for deep customization.
See README for recipes for details.

Also contains several helpers (some of them are based on Ryan Bate's screencast):

```ruby
as_user
close_session
kapify_template
set_default

```

If you want to use these helpers, require `kapify/base` in your `Capfile` or `deploy.rb`

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
