# frozen_string_literal: true

require "rails_helper"

module DefraRubyEmail
  RSpec.describe "LastEmail", type: :request do
    after(:all) { Helpers::Configuration.reset_for_tests }

    let(:path) { "/defra_ruby_email/last-email" }

    context "when mocks are enabled" do
      before(:each) do
        Helpers::Configuration.prep_for_tests
        TestMailer.text_email("test@example.com").deliver_now
      end

      it "returns a JSON response with a 200 code containing details of the last email sent" do
        get path

        expect(response.content_type).to eq("application/json")
        expect(response.code).to eq("200")
        expect(response.body).to eq(LastEmailCache.instance.last_email_json)
      end
    end

    context "when mocks are disabled" do
      before(:all) { DefraRubyEmail.configuration.enable = false }

      it "cannot load the page" do
        expect { get path }.to raise_error(ActionController::RoutingError)
      end
    end
  end
end
