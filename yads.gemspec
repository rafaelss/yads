# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "yads/version"

Gem::Specification.new do |s|
  s.name        = "yads"
  s.version     = Yads::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Rafael Souza"]
  s.email       = ["me@rafaelss.com"]
  s.homepage    = "http://github.com/rafaelss/yads"
  s.summary     = %q{Deploy your code using a YAML file}
  s.description = %q{Simple deployment tool that uses a single YAML file to put your code live}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "net-ssh", "~> 2.1.0"
  s.add_runtime_dependency "slop", "~> 1.5.2"

  s.add_development_dependency "rake", ">= 0.8.7"
  s.add_development_dependency "minitest", "~> 2.0.2"
  s.add_development_dependency "mocha", "~> 0.9.10"
end
