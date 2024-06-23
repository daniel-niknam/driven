module Driven
  module Paths
    class Path
      def initialize(root, current, paths, options = {})
        @paths   = paths
        @current = current
        @root    = root
        @glob    = options[:glob]
        @exclude = options[:exclude]

        options[:eager_load]    ? eager_load!    : skip_eager_load!
        options[:autoload]      ? autoload!      : skip_autoload!
        options[:load_path]     ? load_path!     : skip_load_path!
      end

      %w(eager_load autoload load_path).each do |m|
        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{m}!        # def eager_load!
            @#{m} = true   #   @eager_load = true
          end              # end
                           #
          def skip_#{m}!   # def skip_eager_load!
            @#{m} = false  #   @eager_load = false
          end              # end
                           #
          def #{m}?        # def eager_load?
            @#{m}          #   @eager_load
          end              # end
        RUBY
      end

      # Expands all paths against the root and return all unique values.
      def expanded
        raise "You need to set a path root" unless @root.path
        result = []

        each do |path|
          path = File.expand_path(path, @root.path)

          if @glob && File.directory?(path)
            result.concat files_in(path)
          else
            result << path
          end
        end

        result.uniq!
        result
      end

      def existent
        expanded.select do |f|
          does_exist = File.exist?(f)

          if !does_exist && File.symlink?(f)
            raise "File #{f.inspect} is a symlink that does not point to a valid file"
          end
          does_exist
        end
      end

      def children
        keys = @root.keys.find_all { |k|
          k.start_with?(@current) && k != @current
        }
        @root.values_at(*keys.sort)
      end

      def existent_directories
        expanded.select { |d| File.directory?(d) }
      end

      def each(&block)
        @paths.each(&block)
      end

      private

      def files_in(path)
        files = Dir.glob(@glob, base: path)
        files -= @exclude if @exclude
        files.map! { |file| File.join(path, file) }
        files.sort
      end
    end
  end
end
