# frozen_string_literal: true

module DefraRubyEmail
  class LastEmailObserver

    def self.delivered_email(message)
      LastEmailCache.instance.last_email = message
    end

  end
end

ActionMailer::Base.register_observer(DefraRubyEmail::LastEmailObserver)
