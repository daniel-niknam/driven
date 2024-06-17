# frozen_string_literal: true

require "zeitwerk"
require "thor"
require "tsort"
require "logger"

loader = Zeitwerk::Loader.for_gem
loader.setup
module Driven
  class << self
    @application = @app_class = nil

    attr_writer :application
    attr_accessor :app_class, :logger

    def application
      @application ||= (app_class.instance if app_class)
    end

    def env
      @_env ||= Driven::Misc::EnvironmentInquirer.new(ENV.fetch("DRIVEN_ENV", nil) || ENV.fetch("RACK_ENV", nil) || "development")
    end
  end
end
