# frozen_string_literal: true

require "rails_helper"
require "notifications/client"

module DefraRubyEmail
  RSpec.describe "LastNotifyMessage" do
    after(:all) { Helpers::Configuration.reset_for_tests }

    let(:path) { "/defra_ruby_email/last-notify-message" }

    let(:notify_api_key) { "hello-i-am-a-key" }

    include_context "with a stubbed Notify client"

    context "when the API is enabled" do
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

        expect(response.parsed_body).to eq("last_notify_message" => expected_notify_message)
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
