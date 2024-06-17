module Driven
  class Base
    class Configuration
      def initialize
        @@options ||= {}
      end
    end
  end
end
