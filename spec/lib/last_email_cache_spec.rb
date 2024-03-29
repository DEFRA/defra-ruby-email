# frozen_string_literal: true

require "rails_helper"

module DefraRubyEmail
  RSpec.describe LastEmailCache do
    subject(:instance) { described_class.instance }

    before { instance.reset }

    let(:recipient) { "test@example.com" }
    let(:add_attachment) { false }
    let(:expected_keys) { %w[date from to bcc cc reply_to subject body attachments] }

    describe "#last_email_json" do

      context "when the no emails have been sent" do
        let(:expected_keys) { %w[error] }

        it "returns a JSON string" do
          result = instance.last_email_json

          expect(result).to be_a(String)
          expect { JSON.parse(result) }.not_to raise_error
        end

        it "responds with an error message" do
          result = JSON.parse(instance.last_email_json)

          expect(result.keys).to match_array(expected_keys)
        end
      end

      context "when a basic email is sent" do
        context "and it is formatted as plain text" do
          before { TestMailer.text_email(recipient, add_attachment).deliver_now }

          it "returns a JSON string" do
            result = instance.last_email_json

            expect(result).to be_a(String)
            expect { JSON.parse(result) }.not_to raise_error
          end

          it "contains the attributes of the email" do
            result = JSON.parse(instance.last_email_json)

            expect(result["last_email"].keys).to match_array(expected_keys)
          end

          it "extracts the plain text body content" do
            result = JSON.parse(instance.last_email_json)

            expect(result["last_email"]["body"]).to start_with("This is the text version of an email")
          end
        end

        context "and it is formatted as html" do
          before { TestMailer.html_email(recipient, add_attachment).deliver_now }

          it "returns a JSON string" do
            result = instance.last_email_json

            expect(result).to be_a(String)
            expect { JSON.parse(result) }.not_to raise_error
          end

          it "contains the attributes of the email" do
            result = JSON.parse(instance.last_email_json)

            expect(result["last_email"].keys).to match_array(expected_keys)
          end

          it "extracts the html body content" do
            result = JSON.parse(instance.last_email_json)

            expect(result["last_email"]["body"]).to start_with("<h1>This is the html version of an email</h1>")
          end
        end
      end

      # Multi-part essentially means the email contains more than 2 elements. An
      # element can be a HTML version, and plain text version, and an
      # attachment. If it contains at least 2 of these it will be sent as a
      # multipart email
      context "when a multi-part email is sent" do
        context "and it contains both a html and text version" do
          before { TestMailer.multipart_email(recipient, add_attachment).deliver_now }

          it "returns a JSON string" do
            result = instance.last_email_json

            expect(result).to be_a(String)
            expect { JSON.parse(result) }.not_to raise_error
          end

          it "contains the attributes of the email" do
            result = JSON.parse(instance.last_email_json)

            expect(result["last_email"].keys).to match_array(expected_keys)
          end

          it "extracts the plain text body content" do
            result = JSON.parse(instance.last_email_json)

            expect(result["last_email"]["body"]).to start_with("This is the text version of an email")
          end
        end

        context "and contains both a html and text version plus an attachment" do
          before { TestMailer.multipart_email(recipient, add_attachment).deliver_now }

          let(:add_attachment) { true }

          it "returns a JSON string" do
            result = instance.last_email_json

            expect(result).to be_a(String)
            expect { JSON.parse(result) }.not_to raise_error
          end

          it "contains the attributes of the email" do
            result = JSON.parse(instance.last_email_json)

            expect(result["last_email"].keys).to match_array(expected_keys)
          end

          it "extracts the plain text body content" do
            result = JSON.parse(instance.last_email_json)

            expect(result["last_email"]["body"]).to start_with("This is the text version of an email")
          end
        end

        context "but it just contains a plain text part and an attachment" do
          before { TestMailer.text_email(recipient, add_attachment).deliver_now }

          let(:add_attachment) { true }

          it "returns a JSON string" do
            result = instance.last_email_json

            expect(result).to be_a(String)
            expect { JSON.parse(result) }.not_to raise_error
          end

          it "contains the attributes of the email" do
            result = JSON.parse(instance.last_email_json)

            expect(result["last_email"].keys).to match_array(expected_keys)
          end

          it "extracts the plain text body content" do
            result = JSON.parse(instance.last_email_json)

            expect(result["last_email"]["body"]).to start_with("This is the text version of an email")
          end
        end

        context "but it just contains a html part and an attachment" do
          before { TestMailer.html_email(recipient, add_attachment).deliver_now }

          let(:add_attachment) { true }

          it "returns a JSON string" do
            result = instance.last_email_json

            expect(result).to be_a(String)
            expect { JSON.parse(result) }.not_to raise_error
          end

          it "contains the attributes of the email" do
            result = JSON.parse(instance.last_email_json)

            expect(result["last_email"].keys).to match_array(expected_keys)
          end

          it "extracts the html body content" do
            result = JSON.parse(instance.last_email_json)

            expect(result["last_email"]["body"]).to start_with("<h1>This is the html version of an email</h1>")
          end
        end
      end

      context "when multiple emails have been sent" do
        before do
          TestMailer.text_email(recipient, add_attachment).deliver_now
          TestMailer.text_email(last_recipient, add_attachment).deliver_now
        end

        let(:last_recipient) { "joe.bloggs@example.com" }

        it "returns a JSON string" do
          result = instance.last_email_json

          expect(result).to be_a(String)
          expect { JSON.parse(result) }.not_to raise_error
        end

        it "contains the attributes of the email" do
          result = JSON.parse(instance.last_email_json)

          expect(result["last_email"].keys).to match_array(expected_keys)
        end

        it "extracts the plain text body content" do
          result = JSON.parse(instance.last_email_json)

          expect(result["last_email"]["body"]).to start_with("This is the text version of an email")
        end

        it "contains the details of the last email sent" do
          result = JSON.parse(instance.last_email_json)

          expect(result["last_email"]["to"]).to eq([last_recipient])
        end
      end
    end
  end
end
