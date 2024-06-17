module Driven
  class Application < Engine
    class << self
      def inherited(base)
        super
        Driven.app_class = base
      end

      def instance
        super.run_load_hooks!
      end
    end

    def initialize(&block)
      super
      @initialized = false
      @ran_load_hooks = false
      @autoloaders = nil
      @block = block
    end

    # Initialize the application passing the given group. By default, the
    # group is :default
    def initialize!(group = :default) # :nodoc:
      raise "Application has been already initialized." if @initialized
      run_initializers(group, self)
      @initialized = true
      self
    end

    def initializers # :nodoc:
      Bootstrap.initializers_for(self) +
      base_initializers(super)
    end

    def run_load_hooks!
      return self if @ran_load_hooks
      @ran_load_hooks = true

      instance_eval(&@block) if @block
      self
    end

    def require_environment!
      environment = paths["config/environment"].existent.first
      require environment if environment
    end

    def config # :nodoc:
      @config ||= Application::Configuration.new(self.class.find_root(self.class.called_from))
    end

    protected

    def base_initializers(current)
      initializers = []
      initializers += current # No loop, since there is only one base
      initializers
    end
  end
end
