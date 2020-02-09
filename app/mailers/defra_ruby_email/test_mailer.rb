# frozen_string_literal: true

module DefraRubyEmail
  class TestMailer < ActionMailer::Base
    def basic_email(recipient)
      mail(
        to: recipient,
        from: "defra-ruby-email@example.com",
        subject: "Basic email",
        body: "This is a basic email, so calling `my_email.parts.first.body` would raise an error"
      )
    end

    def multi_part_email(recipient)
      add_logo
      mail(
        to: recipient,
        from: "defra-ruby-email@example.com",
        subject: "Multi-part email",
        body: "This is a multi-part email so calling `my_email.parts.first.body` is fine and will return this text."
      )
    end

    private

    def add_logo
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
