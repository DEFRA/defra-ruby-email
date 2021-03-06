# frozen_string_literal: true

require_relative "configuration"
require_relative "last_email_cache"
require_relative "last_email_observer"
require_relative "last_notify_message"

module DefraRubyEmail
  class Engine < ::Rails::Engine
    isolate_namespace DefraRubyEmail

    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
