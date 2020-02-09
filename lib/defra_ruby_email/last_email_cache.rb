# frozen_string_literal: true

module DefraRubyEmail
  class LastEmailCache
    include Singleton

    EMAIL_ATTRIBUTES = %i[date from to bcc cc reply_to subject].freeze

    attr_accessor :last_email

    # This is necessary to properly test the service functionality
    def reset
      @last_email = nil
    end

    def last_email_json
      return JSON.generate(error: "No emails sent.") unless last_email.present?

      message_hash = {}
      EMAIL_ATTRIBUTES.each do |attribute|
        message_hash[attribute] = last_email.public_send(attribute)
      end
      message_hash[:body] = body
      message_hash[:attachments] = last_email.attachments.map(&:filename)

      JSON.generate(last_email: message_hash)
    end

    def body
      body = last_email&.parts&.first&.body&.to_s

      body ||= last_email.body.to_s

      body
    end
  end
end
