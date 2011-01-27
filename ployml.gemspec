# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ployml/version"

Gem::Specification.new do |s|
  s.name        = "ployml"
  s.version     = Ployml::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Rafael Souza"]
  s.email       = ["me@rafaelss.com"]
  s.homepage    = "http://github.com/rafaelss/ployml"
  s.summary     = %q{Deploy your code using a YAML file}
  s.description = %q{Simple deployment tool that uses a single YAML file to put your code live}

  # s.rubyforge_project = "ployml"

  s.add_runtime_dependency "net-ssh", "~> 2.1.0"
  s.add_development_dependency "minitest", "~> 2.0.2"
  s.add_development_dependency "mocha", "~> 0.9.10"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
