module Kapify
  module Generators
    class Base < Rails::Generators::Base
      argument :templates_path, :type => :string,
        :default => "config/deploy/templates",
        :banner => "path to templates"
    end
  end
end
