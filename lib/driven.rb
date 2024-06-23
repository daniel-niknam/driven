# frozen_string_literal: true

require "zeitwerk"
require "thor"
require "tsort"
require "logger"

loader = Zeitwerk::Loader.for_gem
loader.push_dir("#{__dir__}/driven/app", namespace: Driven)
loader.setup
module Driven
  class << self
    @application = @app_class = nil
    @bounded_contexts = {}

    attr_writer :application
    attr_accessor :app_class, :bounded_contexts, :logger

    def application
      @application ||= (app_class.instance if app_class)
    end

    def env
      @_env ||= Driven::Misc::EnvironmentInquirer.new(ENV.fetch("DRIVEN_ENV", nil) || ENV.fetch("RACK_ENV", nil) || "development")
    end

    # Returns all \Driven groups for loading based on:
    #
    # * The \Driven environment;
    # * The environment variable DRIVEN_GROUPS;
    # * The optional envs given as argument and the hash with group dependencies;
    #
    #  Driven.groups assets: [:development, :test]
    #  # => [:default, "development", :assets] for Driven.env == "development"
    #  # => [:default, "production"]           for Driven.env == "production"
    def groups(*groups)
      env = Driven.env
      groups.unshift(:default, env.to_s)
      groups.concat ENV["DRIVEN_GROUPS"].to_s.split(",")
      groups.compact!
      groups.uniq!
      groups
    end

    def autoloaders
      application.autoloaders
    end
  end
end
