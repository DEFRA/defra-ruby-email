# frozen_string_literal: true

module DefraRubyEmail
  class TestMailer < ActionMailer::Base

    FROM_ADDRESS = "defra-ruby-email@example.com"

    def multipart_email(recipient, add_logo = false)
      add_logo_attachment if add_logo

      mail(
        to: recipient,
        from: FROM_ADDRESS,
        subject: "Multi-part email"
      ) do |format|
        format.html { render html: "<h1>This is the html version of an email</h1>".html_safe }
        format.text { render plain: "This is the text version of an email" }
      end
    end

    def html_email(recipient, add_logo = false)
      add_logo_attachment if add_logo

      mail(
        to: recipient,
        from: FROM_ADDRESS,
        subject: "HTML email"
      ) do |format|
        format.html { render html: "<h1>This is the html version of an email</h1>".html_safe }
      end
    end

    def text_email(recipient, add_logo = false)
      add_logo_attachment if add_logo

      mail(
        to: recipient,
        from: FROM_ADDRESS,
        subject: "Text email"
      ) do |format|
        format.text { render plain: "This is the text version of an email" }
      end
    end

    private

    def add_logo_attachment
      path = "/app/assets/images/defra_ruby_email/govuk_logotype_email.png"

      full_path = File.join(Rails.root, path)

      full_path = "#{Gem.loaded_specs['defra_ruby_email'].full_gem_path}#{path}" unless File.exist?(full_path)

      attachments["govuk_logotype_email.png"] = {
        data: File.read(full_path),
        mime_type: "image/png"
      }
    end
  end
end
