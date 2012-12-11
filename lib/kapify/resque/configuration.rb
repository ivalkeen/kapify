require 'capistrano'
require 'kapify/base'

Capistrano::Configuration.instance.load do
  set_default(:resque_user, user)
  set_default(:resque_workers, 2)
  set_default(:resque_queue, "*")
  set_default(:resque_bundle, "/usr/local/rbenv/shims/bundle")
  set_default(:resque_task, "environment resque:work")

  namespace :kapify do
    namespace :resque do
      desc "Setup Resque initializer and app configuration"
      task :setup, roles: :app do
        run "mkdir -p #{shared_path}/config"
        kapify_template "resque", "resque_init.erb", "/tmp/resque_init"
        run "chmod +x /tmp/resque_init"
        run "#{sudo} mv /tmp/resque_init /etc/init.d/resque_#{application}"
        run "#{sudo} update-rc.d -f resque_#{application} defaults"
      end

      after "deploy:setup", "kapify:resque:setup"

      %w[start stop restart].each do |command|
        desc "#{command} resque"
        task command, roles: :app do
          run "service resque_#{application} #{command}"
        end

        after "deploy:#{command}", "kapify:resque:#{command}"
      end
    end
  end
end
