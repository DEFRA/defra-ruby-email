# frozen_string_literal: true

module DefraRubyEmail
  class Engine < ::Rails::Engine
    isolate_namespace DefraRubyEmail

    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
