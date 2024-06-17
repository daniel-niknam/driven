module Driven
  class Base
    include Initializable

    class << self
      def instance
        @instance ||= new
      end
    end
  end
end
