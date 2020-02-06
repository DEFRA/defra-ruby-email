$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "defra_ruby_email/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "defra_ruby_email"
  s.version     = DefraRubyEmail::VERSION
  s.authors     = ["Alan Cruikshanks"]
  s.email       = ["alan.cruikshanks@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of DefraRubyEmail."
  s.description = "TODO: Description of DefraRubyEmail."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.2.11.1"

  s.add_development_dependency "defra_ruby_style"
end
