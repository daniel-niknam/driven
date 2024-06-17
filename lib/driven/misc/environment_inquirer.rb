module Driven
  module Misc
    class EnvironmentInquirer
      DEFAULT_ENVIRONMENTS = %w[ development test production staging ]
      private_constant :DEFAULT_ENVIRONMENTS
      # Environments that'll respond true for #local?
      LOCAL_ENVIRONMENTS = %w[ development test ]
      private_constant :LOCAL_ENVIRONMENTS

      def initialize(env)
        @env = env
        @local = LOCAL_ENVIRONMENTS.include?(@env)
      end

      def dev?
        @env == "development"
      end
      alias_method :development?, :dev?

      def test?
        @env == "test"
      end

      def production?
        @env == "production"
      end
      alias_method :prod?, :production?

      def staging?
        @env == "staging"
      end

      def to_s
        @env.to_s
      end
    end
  end
end
