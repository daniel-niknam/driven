module Driven
  class Application
    module Finisher
      include Initializable

      initializer :setup_main_autoloader do
        autoloader = Driven.autoloaders.main
        autoloader.setup
      end

      initializer :eager_load! do |app|
        if config.eager_load
          Zeitwerk::Loader.eager_load_all
          Driven.eager_load!
          config.eager_load_namespaces.each(&:eager_load!)
        end
      end
    end
  end
end
