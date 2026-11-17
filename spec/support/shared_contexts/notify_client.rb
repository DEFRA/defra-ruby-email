# frozen_string_literal: true

require "notifications/client"

RSpec.shared_context "with a stubbed Notify client" do
  let(:notification_attributes) do
    {
      type: "email",
      template: "template",
      reference: "foo",
      subject: "Subject",
      body: "Body",
      sent_at: "datetime",
      email_address: "test@example.com",
      phone_number: nil,
      line_1: nil,
      line_2: nil,
      line_3: nil,
      line_4: nil,
      line_5: nil,
      line_6: nil,
      postcode: nil
    }
  end

  let(:notification) { instance_double(Notifications::Client::Notification, notification_attributes) }
  let(:notifications) { instance_double(Notifications::Client::NotificationsCollection, collection: [notification]) }
  let(:client) { instance_double(Notifications::Client, get_notifications: notifications) }

  # The payload LastNotifyMessage#last_notify_message_json is expected to build
  # from the notification above
  let(:expected_notify_message) do
    notification_attributes
      .except(:sent_at, :email_address, :phone_number)
      .merge(
        date: notification_attributes[:sent_at],
        to: notification_attributes[:email_address] || notification_attributes[:phone_number]
      )
      .stringify_keys
  end
end
