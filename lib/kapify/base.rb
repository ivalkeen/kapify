Capistrano::Configuration.instance.load do
  def set_default(name, *args, &block)
    set(name, *args, &block) unless exists?(name)
  end

  def close_sessions
    sessions.values.each { |session| session.close }
    sessions.clear
  end

  def as_user(user_name)
    old_user = user
    set :user, user_name
    close_sessions
    begin
      yield
    ensure
      set :user, old_user
      close_sessions
    end
  end

  def run_interactively(command, server=nil)
    server ||= find_servers_for_task(current_task).first
    exec %Q(ssh #{user}@#{server.host} -p #{port} -t '#{command}')
  end

  set_default(:templates_path, "#{Dir.pwd}/config/deploy/templates")

  def template(from, to)
    erb = File.read(File.expand_path("#{templates_path}/#{from}"))
    put ERB.new(erb).result(binding), to
  end

  def kapify_template(generator, template_name, target)
    config_file = "#{templates_path}/#{template_name}"
    # if no customized file, proceed with default
    unless File.exists?(config_file)
      config_file = File.join(File.dirname(__FILE__), "../generators/kapify/#{generator}/templates/#{template_name}")
    end
    put ERB.new(File.read(config_file)).result(binding), target
  end

end
