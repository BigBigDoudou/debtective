# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)
require_relative "lib/debtective/version"

Gem::Specification.new do |spec|
  spec.name                  = "debtective"
  spec.version               = Debtective::VERSION
  spec.authors               = ["Edouard Piron"]
  spec.email                 = ["ed.piron@gmail.com"]
  spec.homepage              = "https://github.com/BigBigDoudou/debtective"
  spec.summary               = "Find TODOs and compute debt size"
  spec.description           = "Find TODOs and compute debt size"
  spec.license               = "MIT"
  spec.required_ruby_version = ">= 3.0"

  spec.metadata["homepage_uri"]          = spec.homepage
  spec.metadata["source_code_uri"]       = "https://github.com/perangusta/debtective"
  spec.metadata["changelog_uri"]         = "https://github.com/perangusta/debtective/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.add_dependency "git"

  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "rubocop-rspec"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "yard"

  spec.files = Dir["lib/**/*.rb", "lib/tasks/**/*.rake", "MIT-LICENSE", "Rakefile", "README.md"]
end
