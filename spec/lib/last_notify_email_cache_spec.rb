# frozen_string_literal: true

require "rails_helper"

module DefraRubyEmail
  RSpec.describe LastNotifyEmailCache do
    subject(:instance) { described_class.instance }

    before(:each) { instance.reset }

    let(:expected_keys) { %w[body from subject] }
    let(:body) { "This is the body of a Notify email" }
    let(:from_email) { "test@example.com" }
    let(:subject) { "Notify email test" }
    let(:content) do
      {
        "body" => body,
        "from_email" => from_email,
        "subject" => subject,
      }
    end
    let(:notify_response) { double(:notify_response, content: content) }

    describe "#last_notify_email_json" do
      context "when the no emails have been sent" do
        let(:expected_keys) { %w[error] }

        it "returns a JSON string" do
          result = instance.last_notify_email_json

          expect(result).to be_a(String)
          expect { JSON.parse(result) }.to_not raise_error
        end

        it "responds with an error message" do
          result = JSON.parse(instance.last_notify_email_json)

          expect(result.keys).to match_array(expected_keys)
        end
      end

      context "when a basic email is sent" do
        before(:each) { LastNotifyEmailObserver.delivered_notify_email(notify_response) }

        it "returns a JSON string" do
          result = instance.last_notify_email_json

          expect(result).to be_a(String)
          expect { JSON.parse(result) }.to_not raise_error
        end

        it "contains the attributes of the email" do
          result = JSON.parse(instance.last_notify_email_json)

          expect(result["last_notify_email"].keys).to match_array(expected_keys)
        end

        it "has the correct data" do
          result = JSON.parse(instance.last_notify_email_json)
          puts result

          expect(result["last_notify_email"]["body"]).to eq(body)
          expect(result["last_notify_email"]["from"]).to eq(from_email)
          expect(result["last_notify_email"]["subject"]).to eq(subject)
        end
      end

      context "when multiple Notify emails have been sent" do
        let(:second_content) do
          {
            "body": body,
            "from_email": from_email,
            "subject": "Second test",
          }
        end
        let(:second_notify_response) { double(:notify_response, content: second_content) }
        before(:each) do
          LastNotifyEmailObserver.delivered_notify_email(notify_response)
          LastNotifyEmailObserver.delivered_notify_email(second_notify_response)
        end

        it "returns a JSON string" do
          result = instance.last_notify_email_json

          expect(result).to be_a(String)
          expect { JSON.parse(result) }.to_not raise_error
        end

        it "contains the attributes of the email" do
          result = JSON.parse(instance.last_notify_email_json)

          expect(result["last_notify_email"].keys).to match_array(expected_keys)
        end

        it "has the correct data for the last email sent" do
          result = JSON.parse(instance.last_notify_email_json)

          expect(result["last_notify_email"]["body"]).to eq(body)
          expect(result["last_notify_email"]["from"]).to eq(from_email)
          expect(result["last_notify_email"]["subject"]).to eq("Second test")
        end
      end
    end
  end
end
