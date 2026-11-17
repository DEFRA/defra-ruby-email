# frozen_string_literal: true

require "rails_helper"

module DefraRubyEmail
  RSpec.describe LastNotifyMessage do
    subject(:instance) { described_class.instance }

    before { instance.reset }

    include_context "with a stubbed Notify client"

    describe "#retrieve_last_notify_message" do
      it "makes a call to the Notify client" do
        expect(Notifications::Client).to receive(:new).with(DefraRubyEmail.configuration.notify_api_key).and_return(client)
        expect(client).to receive(:get_notifications).and_return(notifications)

        expect(instance.last_notify_message).to be_nil

        instance.retrieve_last_notify_message

        expect(instance.last_notify_message).to eq(notification)
      end
    end

    describe "#last_notify_message_json" do
      context "when no messages have been sent" do
        it "returns a JSON string" do
          result = instance.last_notify_message_json

          expect(result).to be_a(String)
          expect { JSON.parse(result) }.not_to raise_error
        end

        it "responds with an error message" do
          result = JSON.parse(instance.last_notify_message_json)

          expect(result.keys).to match_array(%w[error])
        end
      end

      context "when a message has been sent" do
        before do
          instance.last_notify_message = notification
        end

        it "returns a JSON string" do
          result = instance.last_notify_message_json

          expect(result).to be_a(String)
          expect { JSON.parse(result) }.not_to raise_error
        end

        it "contains the details of the message" do
          result = JSON.parse(instance.last_notify_message_json)

          expect(result["last_notify_message"]).to eq(expected_notify_message)
        end
      end
    end
  end
end
