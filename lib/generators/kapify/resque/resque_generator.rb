require 'generators/kapify/base'

module Kapify
  module Generators
    class ResqueGenerator < Kapify::Generators::Base
      desc "Create local resque configuration files for customization"
      source_root File.expand_path('../templates', __FILE__)

      def copy_template
        copy_file "resque_init.erb", "#{templates_path}/resque_init.erb"
      end
    end
  end
end
