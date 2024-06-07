# frozen_string_literal: true

require_relative "lib/driven/version"

version = Driven::VERSION
Gem::Specification.new do |spec|
  spec.name = "driven"
  spec.version = version
  spec.authors = ["Daniel Niknam"]
  spec.email = ["daniel@niknam.org"]

  spec.summary = "Driven is a Framework inspired by Domain Driven Design"
  spec.description = <<~TEXT
    Driven is a Framework heavily inspired by Domain Driven Design,
     CQRS and Event Driven Architecture.
  TEXT
  spec.homepage = "https://github.com/daniel-niknam/driven"
  spec.license = "MIT"

  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/daniel-niknam/driven/issues",
    "changelog_uri" => "https://github.com/daniel-niknam/driven/releases/tag/v#{version}",
    "source_code_uri" => "https://github.com/daniel-niknam/driven/tree/v#{version}",
    "rubygems_mfa_required" => "true"
  }

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
