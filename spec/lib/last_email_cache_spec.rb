# frozen_string_literal: true

require "rails_helper"

module DefraRubyEmail
  RSpec.describe LastEmailCache do
    subject(:instance) { described_class.instance }

    before(:each) { instance.reset }

    describe "#last_email_json" do

      context "when the no emails have been sent" do
        let(:expected_keys) { %w[error] }

        it "returns a JSON string" do
          result = instance.last_email_json

          expect(result).to be_a(String)
          expect { JSON.parse(result) }.to_not raise_error
        end

        it "responds with an error message" do
          result = JSON.parse(instance.last_email_json)

          expect(result.keys).to match_array(expected_keys)
        end
      end

      context "when an email has been sent" do
        let(:recipient) { "test@example.com" }
        let(:expected_keys) { %w[date from to bcc cc reply_to subject body attachments] }

        context "and its a multi-part email" do
          before(:each) do
            TestMailer.multi_part_email(recipient).deliver_now
          end

          it "returns a JSON string" do
            result = instance.last_email_json

            expect(result).to be_a(String)
            expect { JSON.parse(result) }.to_not raise_error
          end

          it "contains the attributes of the email" do
            result = JSON.parse(instance.last_email_json)

            expect(result["last_email"].keys).to match_array(expected_keys)
          end
        end

        context "and its a basic email" do
          before(:each) do
            TestMailer.basic_email(recipient).deliver_now
          end

          it "returns a JSON string" do
            result = instance.last_email_json

            expect(result).to be_a(String)
            expect { JSON.parse(result) }.to_not raise_error
          end

          it "contains the attributes of the email" do
            result = JSON.parse(instance.last_email_json)

            expect(result["last_email"].keys).to match_array(expected_keys)
          end
        end

        context "when multiple emails have been sent" do
          before(:each) do
            TestMailer.basic_email(first_recipient).deliver_now
            TestMailer.basic_email(second_recipient).deliver_now
          end

          let(:first_recipient) { "test@example.com" }
          let(:second_recipient) { "joe.bloggs@example.com" }

          it "returns a JSON string" do
            result = instance.last_email_json

            expect(result).to be_a(String)
            expect { JSON.parse(result) }.to_not raise_error
          end

          it "contains the attributes of the email" do
            result = JSON.parse(instance.last_email_json)

            expect(result["last_email"].keys).to match_array(expected_keys)
          end

          it "contains the details of the last email sent" do
            result = JSON.parse(instance.last_email_json)

            expect(result["last_email"]["to"]).to eq([second_recipient])
          end
        end

      end
    end

  end
end
