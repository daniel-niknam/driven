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

      def keys
        @root.keys
      end

      def values
        @root.values
      end

      def values_at(*list)
        @root.values_at(*list)
      end

      def all_paths
        values.tap(&:uniq!)
      end

      def autoload_once
        filter_by(&:autoload_once?)
      end

      def eager_load
        filter_by(&:eager_load?)
      end

      def autoload_paths
        filter_by(&:autoload?)
      end

      def load_paths
        filter_by(&:load_path?)
      end

    private
      def filter_by(&block)
        all_paths.find_all(&block).flat_map { |path|
          paths = path.existent_directories
          paths - path.children.flat_map { |p| yield(p) ? [] : p.existent_directories }
        }.uniq
      end
    end
  end
end
