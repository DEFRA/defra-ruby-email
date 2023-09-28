# frozen_string_literal: true

require "rails_helper"
require "notifications/client"

module DefraRubyEmail
  RSpec.describe "LastNotifyMessage" do
    after(:all) { Helpers::Configuration.reset_for_tests }

    let(:path) { "/defra_ruby_email/last-notify-message" }

    let(:notify_api_key) { "hello-i-am-a-key" }
    let(:client) { double(:client, get_notifications: notifications) }
    let(:notifications) { double(:notifications, collection: collection) }
    let(:collection) { double(:collection, first: notification) }
    let(:notification) do
      double(:notification,
             type: "email",
             template: "template",
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
             postcode: nil)
    end

    context "when the API is enabled" do
      let(:expected_data) do
        {
          last_notify_message: {
            type: "email",
            template: "template",
            subject: "Subject",
            body: "Body",
            date: "datetime",
            to: "test@example.com",
            line_1: nil,
            line_2: nil,
            line_3: nil,
            line_4: nil,
            line_5: nil,
            line_6: nil,
            postcode: nil
          }
        }.to_json
      end

      before do
        Helpers::Configuration.prep_for_tests

        expect(DefraRubyEmail.configuration).to receive(:notify_api_key).and_return(notify_api_key)

        expect(Notifications::Client).to receive(:new).with(notify_api_key).and_return(client)
        expect(client).to receive(:get_notifications).and_return(notifications)
      end

      it "returns a JSON response with a 200 code containing details of the last Notify message sent" do
        get path

        expect(response.media_type).to eq("application/json")
        expect(response).to have_http_status(:ok)

        expect(response.body).to eq(expected_data)
      end
    end

    context "when the API is disabled" do
      before(:all) { DefraRubyEmail.configuration.enable = false }

      it "cannot load the page" do
        expect { get path }.to raise_error(ActionController::RoutingError)
      end
    end
  end
end
