module Driven
  class Autoloaders
    attr_reader :main, :bounded_context

    def initialize
      # NOTE: Directly copied form Rails::Autoloaders
      #
      # This `require` delays loading the library on purpose.
      #
      # In Rails 7.0.0, railties/lib/rails.rb loaded Zeitwerk as a side-effect,
      # but a couple of edge cases related to Bundler and Bootsnap showed up.
      # They had to do with order of decoration of `Kernel#require`, something
      # the three of them do.
      #
      # Delaying this `require` up to this point is a convenient trade-off.
      require "zeitwerk"

      @main = Zeitwerk::Loader.new
      @main.tag = "driven.main"

      @bounded_context = Zeitwerk::Loader.new
      @bounded_context.tag = "driven.bounded_context"
    end
  end
end
