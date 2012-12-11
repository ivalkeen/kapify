require 'generators/kapify/base'

module Kapify
  module Generators
    class NginxGenerator < Kapify::Generators::Base
      desc "Create local nginx configuration files for customization"
      source_root File.expand_path('../templates', __FILE__)

      def copy_template
        copy_file "nginx_conf.erb", "#{templates_path}/nginx_conf.erb"
      end
    end
  end
end
