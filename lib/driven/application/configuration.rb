module Driven
  class Application
    class Configuration < Driven::Engine::Configuration
      attr_accessor :logger, :eager_load
      attr_reader :log_level

      def initialize(*)
        super
        @log_level = :debug
        @eager_load = nil
      end

      def paths
        @paths ||= begin
          paths = super
          paths.add "bounded_contexts",   glob: "**/bounded_context.rb"
          paths.add "config/database",    with: "config/database.yml"
          paths.add "config/environment", with: "config/environment.rb"
          paths.add "log",                with: "log/#{Driven.env}.log"
          paths.add "tmp"
          paths
        end
      end
    end
  end
end
