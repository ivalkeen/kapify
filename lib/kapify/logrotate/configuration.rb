require 'capistrano'
require 'kapify/base'

Capistrano::Configuration.instance.load do
  namespace :kapify do
    desc "Setup logs rotation for application logs"
    task :logrotate, except: { no_release: true } do
      kapify_template("logrotate", "logrotate.erb", "/tmp/#{application}_logrotate")
      run "#{sudo} mv /tmp/#{application}_logrotate /etc/logrotate.d/#{application}"
      run "#{sudo} chown root:root /etc/logrotate.d/#{application}"
    end

    after "deploy:setup", "kapify:logrotate"
  end
end
