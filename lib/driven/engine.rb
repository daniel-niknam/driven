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
