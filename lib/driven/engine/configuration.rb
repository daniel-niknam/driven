module Driven
  class Engine
    class Configuration < Base::Configuration
      attr_reader :autoload_paths, :eager_load_paths

      def initialize(root = nil)
        super()
        @root = root

        @autoload_paths = []
        @autoload_once_paths = []
        @eager_load_paths = []
      end

      def paths
        @paths ||= begin
          paths = Driven::Paths::Root.new(@root)
          # If you add more lib subdirectories here that should not be managed
          # by the main autoloader, please update the config.autoload_lib call
          # in the template that generates config/application.rb accordingly.
          paths.add "lib",                 load_path: true
          paths.add "lib/tasks",           glob: "**/*.rake"

          paths.add "config"
          paths.add "config/environments", glob: -"#{Driven.env}.rb"
          paths.add "config/initializers", glob: "**/*.rb"

          paths
        end
      end

      def all_autoload_paths # :nodoc:
        autoload_paths + paths.autoload_paths
      end

      def all_eager_load_paths # :nodoc:
        eager_load_paths + paths.eager_load
      end
    end
  end
end
