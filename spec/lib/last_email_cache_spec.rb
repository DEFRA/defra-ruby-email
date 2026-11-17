# frozen_string_literal: true

require "rails_helper"

module DefraRubyEmail
  RSpec.describe LastEmailCache do
    subject(:instance) { described_class.instance }

    before { instance.reset }

    let(:recipient) { "test@example.com" }
    let(:expected_keys) { %w[date from to bcc cc reply_to subject body attachments] }
    let(:json) { instance.last_email_json }
    let(:result) { JSON.parse(json) }

    text_body = "This is the text version of an email"
    html_body = "<h1>This is the html version of an email</h1>"

    shared_examples "a valid last email JSON" do |body_start|
      it "returns a JSON string" do
        expect { JSON.parse(json) }.not_to raise_error
      end

      it "contains the attributes of the email" do
        expect(result["last_email"].keys).to match_array(expected_keys)
      end

      it "extracts the body content" do
        expect(result["last_email"]["body"]).to start_with(body_start)
      end
    end

    describe "#last_email_json" do
      context "when no emails have been sent" do
        it "returns a JSON string" do
          expect { JSON.parse(json) }.not_to raise_error
        end

        it "responds with an error message" do
          expect(result.keys).to match_array(%w[error])
        end
      end

      # Multi-part essentially means the email contains more than 2 elements. An
      # element can be a HTML version, and plain text version, and an
      # attachment. If it contains at least 2 of these it will be sent as a
      # multipart email
      {
        "a plain text email" => [:text_email, false, text_body],
        "an html email" => [:html_email, false, html_body],
        "a multi-part email with html and text versions" => [:multipart_email, false, text_body],
        "a multi-part email with html and text versions plus an attachment" => [:multipart_email, true, text_body],
        "a multi-part email with just a plain text part and an attachment" => [:text_email, true, text_body],
        "a multi-part email with just an html part and an attachment" => [:html_email, true, html_body]
      }.each do |description, (mailer_method, add_attachment, body_start)|
        context "when #{description} is sent" do
          before { TestMailer.public_send(mailer_method, recipient, add_attachment).deliver_now }

          it_behaves_like "a valid last email JSON", body_start
        end
      end

      context "when multiple emails have been sent" do
        before do
          TestMailer.text_email(recipient, false).deliver_now
          TestMailer.text_email(last_recipient, false).deliver_now
        end

        let(:last_recipient) { "joe.bloggs@example.com" }

        it_behaves_like "a valid last email JSON", text_body

        it "contains the details of the last email sent" do
          expect(result["last_email"]["to"]).to eq([last_recipient])
        end
      end
    end
  end
end
