# frozen_string_literal: true

require "notifications/client"

module DefraRubyEmail
  class LastNotifyMessage
    include Singleton

    LETTER_ATTRIBUTES = %i[line_1 line_2 line_3 line_4 line_5 line_6 postcode].freeze

    attr_accessor :last_notify_message

    # This is necessary to properly test the service functionality
    def reset
      @last_notify_message = nil
    end

    def get_last_notify_message
      client = Notifications::Client.new(DefraRubyEmail.configuration.notify_api_key)
      response = client.get_notifications
      @last_notify_message = response.collection.first
    end

    def last_notify_message_json
      return JSON.generate(error: "No messages sent.") unless last_notify_message.present?

      message_hash = {}
      message_hash[:type] = last_notify_message.type
      message_hash[:template] = last_notify_message.template
      message_hash[:subject] = last_notify_message.subject
      message_hash[:body] = last_notify_message.body
      message_hash[:date] = last_notify_message.sent_at

      # Email and phone-specific attributes
      message_hash[:to] = last_notify_message.email_address || last_notify_message.phone_number
      # Letter-specific attributes
      LETTER_ATTRIBUTES.each do |attribute|
        message_hash[attribute] = last_notify_message.public_send(attribute)
      end

      JSON.generate(last_notify_message: message_hash)
    end
  end
end
