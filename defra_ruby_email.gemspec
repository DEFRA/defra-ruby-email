# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "defra_ruby_email/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "defra_ruby_email"
  s.version     = DefraRubyEmail::VERSION
  s.authors     = ["Defra"]
  s.email       = ["alan.cruikshanks@environment-agency.gov.uk"]
  s.homepage    = "https://github.com/DEFRA/defra-ruby-email"
  s.summary     = "Defra Ruby on Rails access last email engine"
  s.description = "A Rails engine which can be used to access details of the last email when loaded into an application"
  s.license     = "The Open Government Licence (OGL) Version 3"
  s.required_ruby_version = ">= 3.1"
  s.metadata["rubygems_mfa_required"] = "true"
  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.md"]

  # Don't pin the rails version, leave that to the applications
  s.add_dependency "rails"

  s.add_dependency "sprockets-rails"

  # We want to be able to make requests to Notify and understand Notify objects
  s.add_dependency "notifications-ruby-client"
end
