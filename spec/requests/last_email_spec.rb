# frozen_string_literal: true

require "rails_helper"

module DefraRubyEmail
  RSpec.describe "Test", type: :request do
    after(:all) { Helpers::Configuration.reset_for_tests }

    let(:path) { "/defra_ruby_email/test" }

    context "when mocks are enabled" do
      before(:each) { Helpers::Configuration.prep_for_tests }

      it "renders the appropriate template" do
        get path
        expect(response).to render_template("defra_ruby_email/test/show")
      end

      it "responds to the GET request with a 200 status code" do
        get path
        expect(response.code).to eq("200")
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
