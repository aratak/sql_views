# -*- encoding: utf-8 -*-

if RUBY_VERSION == '1.8.7'
  $:.unshift File.expand_path("../lib", __FILE__)
  require "sql_views/version"
else
  # ruby 1.9
  require File.expand_path('../lib/sql_views/version', __FILE__)
end

Gem::Specification.new do |gem|
  gem.name          = "sql_views"
  gem.authors       = ["Alexey Osipenko"]
  gem.email         = ["alexey@osipenko.in.ua"]
  gem.description   = %q{Adds support for using SQL views within ActiveRecord}
  gem.summary       = %q{Adds support for using SQL views within ActiveRecord}
  gem.homepage      = "http://aratak.github.com/sql_views"
  gem.date            = Time.new.strftime "%Y-%m-%d"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.version       = SqlViews::VERSION

  gem.add_dependency "activerecord", "> 3.0"
end
