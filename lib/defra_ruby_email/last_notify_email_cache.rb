# frozen_string_literal: true

module DefraRubyEmail
  class LastNotifyEmailCache
    include Singleton

    NOTIFICATION_ATTRIBUTES = %i[from_email subject body].freeze

    attr_accessor :last_notify_email

    # This is necessary to properly test the service functionality
    def reset
      @last_notify_email = nil
    end

    def last_notify_email_json
      return JSON.generate(error: "No Notify emails sent.") unless last_notify_email.present?

      message_hash = {}
      message_hash[:body] = last_notify_email.content["body"]
      message_hash[:from] = last_notify_email.content["from_email"]
      message_hash[:subject] = last_notify_email.content["subject"]

      JSON.generate(last_notify_email: message_hash)
    end
  end
end
