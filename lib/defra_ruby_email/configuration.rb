# frozen_string_literal: true

module DefraRubyEmail
  class Configuration

    def initialize
      @enable = false
    end

    # Controls whether the mocks are enabled. Only if set to true will the mock
    # pages be accessible
    def enable=(arg)
      # We implement our own setter to handle values being passed in as strings
      # rather than booleans
      parsed = arg.to_s.downcase

      @enable = parsed == "true"
    end

    def enabled?
      @enable
    end
  end
end
