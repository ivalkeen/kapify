require 'generators/kapify/base'

module Kapify
  module Generators
    class LogrotateGenerator < Kapify::Generators::Base
      desc "Create logrotate configuration files for customization"
      source_root File.expand_path('../templates', __FILE__)

      def copy_template
        copy_file "logrotate.erb", "#{templates_path}/logrotate.erb"
      end
    end
  end
end
