require 'capistrano'
require 'kapify/base'

Capistrano::Configuration.instance.load do
  set_default(:nginx_server_name) { Capistrano::CLI.ui.ask "Nginx server name: " }
  set_default(:nginx_use_ssl, false)
  set_default(:nginx_ssl_certificate) { "#{nginx_server_name}.crt" }
  set_default(:nginx_ssl_certificate_key) { "#{nginx_server_name}.key" }
  set_default(:nginx_ssl_certificate_local_path) { Capistrano::CLI.ui.ask "Local path to ssl certificate (leave blank to skip): " }
  set_default(:nginx_ssl_certificate_key_local_path) { Capistrano::CLI.ui.ask "Local path to ssl certificate key: " }

  namespace :kapify do
    namespace :nginx do
      desc "Setup nginx configuration for this application"
      task :setup, roles: :web do
        kapify_template("nginx", "nginx_conf.erb", "/tmp/#{application}")
        run "#{sudo} mv /tmp/#{application} /etc/nginx/sites-available/#{application}"
        run "#{sudo} ln -fs /etc/nginx/sites-available/#{application} /etc/nginx/sites-enabled/#{application}"

        if nginx_use_ssl && !nginx_ssl_certificate_local_path.empty?
          put File.read(nginx_ssl_certificate_local_path), "/tmp/#{nginx_ssl_certificate}"
          put File.read(nginx_ssl_certificate_key_local_path), "/tmp/#{nginx_ssl_certificate_key}"

          run "#{sudo} mv /tmp/#{nginx_ssl_certificate} /etc/ssl/certs/#{nginx_ssl_certificate}"
          run "#{sudo} mv /tmp/#{nginx_ssl_certificate_key} /etc/ssl/private/#{nginx_ssl_certificate_key}"

          run "#{sudo} chown root:root /etc/ssl/certs/#{nginx_ssl_certificate}"
          run "#{sudo} chown root:root /etc/ssl/private/#{nginx_ssl_certificate_key}"
        end
      end

      after "deploy:setup", "kapify:nginx:setup"
      after "deploy:setup", "kapify:nginx:reload"

      desc "Reload nginx configuration"
      task :reload, roles: :web do
        run "#{sudo} /etc/init.d/nginx reload"
      end
    end
  end
end
