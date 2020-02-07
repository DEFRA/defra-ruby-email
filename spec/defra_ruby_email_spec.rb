# frozen_string_literal: true

require "rails_helper"

RSpec.describe DefraRubyEmail do
  describe "VERSION" do
    it "is a version string in the correct format" do
      expect(DefraRubyEmail::VERSION).to be_a(String)
      expect(DefraRubyEmail::VERSION).to match(/\d+\.\d+\.\d+/)
    end
  end

  describe "#configuration" do
    before(:each) { Helpers::Configuration.reset_for_tests }

    context "when the host app has not provided configuration" do
      let(:enabled) { false }

      it "returns a DefraRubyEmail::Configuration instance with default values" do
        expect(described_class.configuration).to be_an_instance_of(DefraRubyEmail::Configuration)

        expect(described_class.configuration.enabled?).to eq(enabled)
      end
    end

    context "when the host app has provided configuration" do
      let(:enabled) { true }

      it "returns a DefraRubyEmail::Configuration instance with matching values" do
        described_class.configure do |config|
          config.enable = enabled
        end

        expect(described_class.configuration).to be_an_instance_of(DefraRubyEmail::Configuration)
        expect(described_class.configuration.enabled?).to eq(enabled)
      end
    end
  end
end
