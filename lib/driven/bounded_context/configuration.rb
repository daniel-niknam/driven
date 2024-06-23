module Driven
  class BoundedContext
    class Configuration < Engine::Configuration

      attr_reader :autoload_paths

      def paths
        @paths ||= begin
          paths = super
          paths.add "app/aggregates", eager_load: true
          paths.add "app/commands",   eager_load: true
          paths.add "app/queries",    eager_load: true
          paths.add "app/events",     eager_load: true
          paths.add "app/policies",   eager_load: true
          paths
        end
      end
    end
  end
end
