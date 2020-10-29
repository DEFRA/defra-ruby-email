# frozen_string_literal: true

module DefraRubyEmail
  class LastNotifyEmailObserver

    def self.delivered_notify_email(response)
      LastNotifyEmailCache.instance.last_notify_email = response
    end

  end
end
