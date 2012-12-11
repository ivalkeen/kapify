require 'generators/kapify/base'

module Kapify
  module Generators
    class PgGenerator < Kapify::Generators::Base
      desc "Create local database.yml.erb configuration files for customization"
      source_root File.expand_path('../templates', __FILE__)

      def copy_template
        copy_file "database.yml.erb", "#{templates_path}/database.yml.erb"
      end
    end
  end
end
