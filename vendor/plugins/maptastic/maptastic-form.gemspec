# -*- encoding: utf-8 -*-
#require 'lib/maptastic-form/version'
 
Gem::Specification.new do |s|
  s.name        = "maptastic-form"
  s.version     = '0.1.3'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Matt Hall"]
  s.email       = ["matt@codebeef.com"]
  s.homepage    = "http://codebeef.com/projects/maptastic"
  s.summary     = "The fastest way of adding maps to Formtastic forms"
  s.description = "Provides a map type to Formtastic, allowing you to easily add location selectors to your apps."
 
  s.files        = Dir.glob("{lib}/**/*") + %w(MIT-LICENSE README.markdown)
  
  s.add_dependency(%q<rails>, ["~> 3.0"])
  s.add_development_dependency(%q<formtastic>, ["~> 2.0"])
end