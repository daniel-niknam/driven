module Driven
  class Application
    module Bootstrap
      include Initializable

      initializer :load_environment_hook, group: :all do end

      # Initialize the logger early in the stack in case we need to log some deprecation.
      initializer :initialize_logger, group: :all do
        Driven.logger ||= config.logger || begin
          logger = Logger.new(STDOUT)
          logger.level = config.log_level || Logger::WARN
          logger
        end
      end
    end
  end
end
