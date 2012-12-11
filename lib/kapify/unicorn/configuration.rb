require 'capistrano'
require 'kapify/base'

Capistrano::Configuration.instance.load do
  set_default(:unicorn_pid, "#{current_path}/tmp/pids/unicorn.pid")
  set_default(:unicorn_config, "#{shared_path}/config/unicorn.rb")
  set_default(:unicorn_log, "#{shared_path}/log/unicorn.log")
  set_default(:unicorn_user, user)
  set_default(:unicorn_workers) { Capistrano::CLI.ui.ask "Number of unicorn workers: " }

  namespace :kapify do
    namespace :unicorn do
      desc "Setup Unicorn initializer and app configuration"
      task :setup, roles: :app do
        run "mkdir -p #{shared_path}/config"
        kapify_template "unicorn", "unicorn.rb.erb", unicorn_config
        kapify_template "unicorn", "unicorn_init.erb", "/tmp/unicorn_init"
        run "chmod +x /tmp/unicorn_init"
        run "#{sudo} mv /tmp/unicorn_init /etc/init.d/unicorn_#{application}"
        run "#{sudo} update-rc.d -f unicorn_#{application} defaults"
      end

      after "deploy:setup", "kapify:unicorn:setup"

      %w[start stop restart].each do |command|
        desc "#{command} unicorn"
        task command, roles: :app do
          run "service unicorn_#{application} #{command}"
        end

        after "deploy:#{command}", "kapify:unicorn:#{command}"
      end
    end
  end
end
