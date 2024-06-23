module Driven
  class BoundedContext
    module Finisher
      include Initializable

      initializer :setup_bounded_context_autoloader do
        autoloader = Driven.autoloaders.bounded_context
        already_configured_dirs = Set.new(autoloader.dirs)

        config.autoload_paths.uniq.each do |path|
          # Zeitwerk only accepts existing directories in `push_dir`.
          next unless File.directory?(path)
          next if already_configured_dirs.member?(path.to_s)

          autoloader.push_dir(path, namespace: bounded_context_module)
          autoloader.do_not_eager_load(path) unless config.eager_load_paths.member?(path)
        end
        autoloader.setup
      end
    end
  end
end
