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

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 6.0"
  # Pin version of sprockers. Rails 4.2.11.3 seems to want to bring in version
  # 4.0.0 of sprockets (even though that version is not directly referenced in
  # the rails gemspec or Gemfile.lock) however that requires ruby 2.5 as a
  # minimum
  s.add_dependency "sprockets", "~> 3.7.2"

  s.add_development_dependency "defra_ruby_style"

  # We want to be able to make requests to Notify and understand Notify objects
  s.add_dependency "notifications-ruby-client"

  # Allows us to automatically generate the change log from the tags, issues,
  # labels and pull requests on GitHub. Added as a dependency so all dev's have
  # access to it to generate a log, and so they are using the same version.
  # New dev's should first create GitHub personal app token and add it to their
  # ~/.bash_profile (or equivalent)
  # https://github.com/skywinder/github-changelog-generator#github-token
  s.add_development_dependency "github_changelog_generator"
  s.add_development_dependency "pry-byebug"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "simplecov", "~> 0.17.1"
end
