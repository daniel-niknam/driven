require "thor"
require "irb"

module Driven
  class Command < Thor
    desc("console", "Starts the console")
    def console
      boot_application!

      IRB.setup(nil)
      IRB::Irb.new.run(IRB.conf)
    end

    private

    def require_application!
      require APP_PATH if defined?(APP_PATH)
    end

    def boot_application!
      require_application!
      Driven.application.require_environment! if defined?(APP_PATH)
    end
  end
end

