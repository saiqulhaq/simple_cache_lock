# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "simple_cache_lock/version"

Gem::Specification.new do |spec|
  spec.name = "simple_cache_lock"
  spec.version = SimpleCacheLock::VERSION
  spec.authors = ["Saiqul Haq"]
  spec.email = ["saiqulhaq@gmail.com"]

  spec.summary = "Don't let your cache writes same data multiple times"
  spec.description = "Uses redlock-rb and Timeout class"
  spec.homepage = "https://github.com/saiqulhaq/simple_cache_lock"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.5"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.3"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "mock_redis", "0.31.0"

  spec.add_dependency "gem_config", "~> 0.3", ">= 0.3"
  spec.add_dependency "redlock", "~> 1.0", ">= 1.0.0"
  spec.add_dependency "sorbet-runtime"
end
