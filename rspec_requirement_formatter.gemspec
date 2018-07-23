
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rspec_requirement_formatter/version"

Gem::Specification.new do |spec|
  spec.name          = "rspec_requirement_formatter"
  spec.version       = RspecRequirementFormatter::VERSION
  spec.authors       = ["yensaki"]
  spec.email         = ["mov.an.double@gmail.com"]

  spec.summary       = 'This gem show html format rspecs'
  spec.description   = 'This gem show html format rspecs'
  spec.homepage      = "https://github.com/yensaki/rspec_requirement_formatter"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rspec-core", "3.7.1"
  spec.add_dependency "rspec", "~> 3.0"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
end
