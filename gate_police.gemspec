# -*- encoding: utf-8 -*-
require File.expand_path('../lib/gate_police/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["miio"]
  gem.email         = ["info@miio.info"]
  gem.description   = %q{Permission for rails library}
  gem.summary       = %q{Permission for rails library}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "gate_police"
  gem.require_paths = ["lib"]
  gem.version       = GatePolice::VERSION
end
