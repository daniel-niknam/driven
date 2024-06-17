module Driven
  class Engine
    class Configuration < Base::Configuration
      def initialize(root = nil)
        super()
        @root = root
      end

      def paths
        @paths ||= begin
          paths = Driven::Paths::Root.new(@root)

          paths.add "apps"

          # If you add more lib subdirectories here that should not be managed
          # by the main autoloader, please update the config.autoload_lib call
          # in the template that generates config/application.rb accordingly.
          paths.add "lib",                 load_path: true
          paths.add "lib/tasks",           glob: "**/*.rake"

          paths.add "config"
          paths.add "config/environments", glob: -"#{Driven.env}.rb"
          paths.add "config/initializers", glob: "**/*.rb"
          paths.add "config/locales",      glob: "**/*.{rb,yml}"

          paths
        end
      end
    end
  end
end
