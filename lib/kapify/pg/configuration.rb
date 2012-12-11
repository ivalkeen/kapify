require 'capistrano'
require 'kapify/base'

Capistrano::Configuration.instance.load do
  set_default(:pg_host) { find_servers(roles: :pg)[0] || "localhost" }
  set_default(:pg_port, "5432")
  set_default(:pg_database, application)
  set_default(:pg_pool, 5)
  set_default(:pg_user, application)
  set_default(:pg_password) { Capistrano::CLI.password_prompt "PG password: " }
  set_default(:pg_create_db, true)

  namespace :kapify do
    namespace :pg do
      desc "Create user for application"
      task :create_user, roles: :pg do
        pg_params = "-p #{pg_port}"
        check_user = %Q[#{sudo} -u postgres psql #{pg_params} postgres -c "select * from pg_user where usename='#{pg_user}'" | grep -c '#{pg_user}']
        add_user = %Q[#{sudo} -u postgres psql #{pg_params} -c "create user #{pg_user}"]
        run "#{check_user} || #{add_user}"
        run %Q{#{sudo} -u postgres psql #{pg_params} -c "alter user #{pg_user} with password '#{pg_password}'" }
      end

      desc "Create database for application"
      task :create_database, roles: :pg do
        if pg_create_db
          run %Q{#{sudo} -u postgres psql -c "create database #{pg_database} owner #{pg_user};"}
        end
      end

      if find_servers(roles: :pg).size > 0
        after "deploy:setup", "kapify:pg:create_user"
        after "deploy:setup", "kapify:pg:create_database"
      end

      desc "Generate the database.yml configuration file."
      task :setup, roles: :app do
        run "mkdir -p #{shared_path}/config"
        kapify_template("pg", "database.yml.erb", "#{shared_path}/config/database.yml")
      end

      after "deploy:setup", "kapify:pg:setup"

      desc "Symlink the database.yml file into latest release"
      task :symlink, roles: :app do
        run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
      end

      after "deploy:finalize_update", "kapify:pg:symlink"
    end
  end
end
