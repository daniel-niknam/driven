module Driven
  class Application
    class Configuration < Driven::Engine::Configuration
      attr_accessor :logger
      attr_reader :log_level

      def initialize(*)
        super
        @log_level = :debug
      end

      def paths
        @paths ||= begin
          paths = super
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
