require 'generators/kapify/base'

module Kapify
  module Generators
    class UnicornGenerator < Kapify::Generators::Base
      desc "Create local unicorn configuration files for customization"
      source_root File.expand_path('../templates', __FILE__)

      def copy_template
        copy_file "unicorn.rb.erb", "#{templates_path}/unicorn.rb.erb"
        copy_file "unicorn_init.erb", "#{templates_path}/unicorn_init.erb"
      end
    end
  end
end
