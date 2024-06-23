module Driven
  class Application < Engine
    class << self
      def inherited(base)
        super
        Driven.app_class = base
        Driven.bounded_contexts = {}
      end

      def instance
        super.run_load_hooks!
      end
    end

    attr_reader :autoloaders

    def initialize(&block)
      super
      @initialized = false
      @ran_load_hooks = false
      @autoloaders = Driven::Autoloaders.new
      @block = block
    end

    # Initialize the application passing the given group. By default, the
    # group is :default
    def initialize!(group = :default) # :nodoc:
      raise "Application has been already initialized." if @initialized
      run_initializers(group, self)
      require_bounded_contexts!
      initialize_bounded_contexts
      @initialized = true
      self
    end

    def initializers # :nodoc:
      Bootstrap.initializers_for(self) +
      base_initializers(super) +
      Finisher.initializers_for(self)
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

    def require_bounded_contexts!
      paths["bounded_contexts"].existent.each do |bounded_context|
        require bounded_context
      end
    end

    def initialize_bounded_contexts
      Driven.bounded_contexts.each do |bounded_context, _app|
        bounded_context.instance.initialize!
      end
    end

    def config # :nodoc:
      @config ||= Application::Configuration.new(self.class.find_root(self.class.called_from))
    end

    protected

    def base_initializers(current)
      initializers = Initializable::Collection.new
      initializers += current
      initializers
    end
  end
end
