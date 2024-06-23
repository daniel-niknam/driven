module Driven
  class Engine < Base
    extend Forwardable
    def_delegator :config, :paths

    class << self
      attr_accessor :called_from

      def inherited(base)
        base.called_from = begin
          call_stack = caller_locations.map { |l| l.absolute_path || l.path }

          File.dirname(call_stack.detect { |p| !p.match?(%r[driven[\w.-]*/lib/driven|rack[\w.-]*/lib/rack]) })
        end

        super
      end

      def find_root(from)
        find_root_with_flag "lib", from
      end
    end
    def config
      @config ||= Engine::Configuration.new(self.class.find_root(self.class.called_from))
    end

    initializer :load_config_environment, before: :load_environment_hook, group: :all do
      paths["config/environments"].existent.each do |environment|
        require environment
      end
    end

    initializer :load_config_initializers do
      config.paths["config/initializers"].existent.sort.each do |initializer|
        require initializer
      end
    end

    initializer :set_autoload_paths, before: :bootstrap_hook do
      config.autoload_paths.unshift(*_all_autoload_paths)
      config.autoload_paths.freeze
    end

    initializer :set_eager_load_paths, before: :bootstrap_hook do
      config.eager_load_paths.unshift(*config.all_eager_load_paths)
      config.eager_load_paths.freeze
    end


    protected

    def _all_autoload_paths
      @_all_autoload_paths ||= begin
        autoload_paths  = config.all_autoload_paths
        autoload_paths += config.all_eager_load_paths
        autoload_paths.uniq
      end
    end

    def _all_load_paths(add_autoload_paths_to_load_path)
      @_all_load_paths ||= begin
        load_paths = config.paths.load_paths
        if add_autoload_paths_to_load_path
          load_paths += _all_autoload_paths
        end
        load_paths.uniq
      end
    end

    private

    def self.find_root_with_flag(flag, root_path, default = nil) # :nodoc:
      while root_path && File.directory?(root_path) && !File.exist?("#{root_path}/#{flag}")
        parent = File.dirname(root_path)
        root_path = parent != root_path && parent
      end

      root = File.exist?("#{root_path}/#{flag}") ? root_path : default
      raise "Could not find root path for #{self}" unless root

      Pathname.new File.realpath root
    end
  end
end
