# frozen_string_literal: true

module Helpers
  module Configuration
    def self.prep_for_tests(delay = 100)
      DefraRubyEmail.reset_configuration
      DefraRubyEmail.configure do |config|
        config.enable = true
      end
    end

    def self.reset_for_tests
      DefraRubyEmail.reset_configuration
    end
  end
end
