# -*- encoding: utf-8 -*-
require File.expand_path("../lib/temporal/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "temporal"
  s.version     = Temporal::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Clive Crous"]
  s.email       = ["clive@crous.co.za"]
  s.homepage    = "https://github.com/clivecrous/temporal"
  s.summary     = "A natural language date and time parser"
  s.description = "This project is still in early development. Only the mathematical side is complete. eg: Time.now + 3.years + 2.months"

  s.required_rubygems_version = ">= 1.3.6"

  s.add_development_dependency "bundler", ">= 1.0.0"
  s.add_development_dependency "rspec", ">= 1.3.0"
  s.add_development_dependency "rake", ">= 0.8.7"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
