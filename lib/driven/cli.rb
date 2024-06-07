module Driven
  class Cli < Thor
    desc "foo", "Prints foo"
    def foo
      puts "foo command"
    end
  end
end
