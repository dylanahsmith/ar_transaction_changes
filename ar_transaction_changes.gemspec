# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ar_transaction_changes/version'

Gem::Specification.new do |gem|
  gem.name          = "ar_transaction_changes"
  gem.version       = ArTransactionChanges::VERSION
  gem.authors       = ["Dylan Smith"]
  gem.email         = ["Dylan.Smith@shopify.com"]
  gem.description   = %q{Solves the problem of trying to get all the changes to an object during a transaction in an after_commit callbacks.}
  gem.summary       = %q{Store transaction changes for active record objects}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency("activerecord", [">= 3.0.0"])

  gem.add_development_dependency("mysql2")
  gem.add_development_dependency("rake")
  gem.add_development_dependency("pry")
end
