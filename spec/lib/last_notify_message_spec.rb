# frozen_string_literal: true

require "rails_helper"

module DefraRubyEmail
  RSpec.describe LastNotifyMessage do
    subject(:instance) { described_class.instance }

    before(:each) { instance.reset }

    let(:client) { double(:client, get_notifications: notifications) }
    let(:notifications) { double(:notifications, collection: collection) }
    let(:collection) { double(:collection, first: notification) }
    let(:notification) do
      double(:notification,
             type: "email",
             subject: "Subject",
             body: "Body",
             sent_at: "datetime",
             email_address: "test@example.com",
             line_1: nil,
             line_2: nil,
             line_3: nil,
             line_4: nil,
             line_5: nil,
             line_6: nil,
             postcode: nil)
    end

    let(:expected_keys) { %w[type subject body date to line_1 line_2 line_3 line_4 line_5 line_6 postcode] }

    describe "#get_last_notify_message" do
      it "makes a call to the Notify client" do
        expect(Notifications::Client).to receive(:new).with(ENV["NOTIFY_API_KEY"]).and_return(client)
        expect(client).to receive(:get_notifications).and_return(notifications)

        expect(instance.last_notify_message).to eq(nil)

        instance.get_last_notify_message

        expect(instance.last_notify_message).to eq(notification)
      end
    end

    describe "#last_notify_message_json" do
      context "when no messages have been sent" do
        let(:expected_keys) { %w[error] }

        it "returns a JSON string" do
          result = instance.last_notify_message_json

          expect(result).to be_a(String)
          expect { JSON.parse(result) }.to_not raise_error
        end

        it "responds with an error message" do
          result = JSON.parse(instance.last_notify_message_json)

          expect(result.keys).to match_array(expected_keys)
        end
      end

      context "when a message has been sent" do
        before(:each) { instance.get_last_notify_message }

        it "returns a JSON string" do
          result = instance.last_notify_message_json

          expect(result).to be_a(String)
          expect { JSON.parse(result) }.to_not raise_error
        end

        it "contains the attributes of the message" do
          result = JSON.parse(instance.last_notify_message_json)

          expect(result["last_notify_message"].keys).to match_array(expected_keys)
        end
      end
    end
  end
end
