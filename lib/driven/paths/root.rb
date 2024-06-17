module Driven
  module Paths
    class Root
      attr_accessor :path

      def initialize(path)
        @path = path
        @root = {}
      end

      def add(path, options = {})
        with = Array(options.fetch(:with, path))
        @root[path] = Path.new(self, path, with, options)
      end

      def [](path)
        @root[path]
      end
    end
  end
end
