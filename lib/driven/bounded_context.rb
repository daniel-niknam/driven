module Driven
  class BoundedContext < Engine
    class << self
      def inherited(base)
        super
        Driven.bounded_contexts[base] = nil
      end

      def instance
        super.run_load_hooks!
      end

      def find_root(from)
        Pathname.new(from)
      end
    end

    def run_load_hooks!
      return self if @ran_load_hooks
      @ran_load_hooks = true

      instance_eval(&@block) if @block
      self
    end

    # Initialize the application passing the given group. By default, the
    # group is :default
    def initialize!(group = :default) # :nodoc:
      raise "Bounded Context #{self.inspect} has been already initialized." if @initialized
      run_initializers(group, self)
      @initialized = true
      self
    end

    def initializers # :nodoc:
      base_initializers(super) +
      Finisher.initializers_for(self)
    end

    def config # :nodoc:
      @config ||= BoundedContext::Configuration.new(self.class.find_root(self.class.called_from))
    end

    protected

    def bounded_context_module
      bounded_context_module_name = self.class.to_s.split("::").first
      bounded_context_module = Object.const_get(bounded_context_module_name)
    end

    def base_initializers(current)
      initializers = Initializable::Collection.new
      initializers += current
      initializers
    end
  end
end
