# frozen_string_literal: true

namespace :defra_ruby_email do
  desc "Send a test email to confirm setup is correct"
  task test: :environment do
    recipient = ENV["EMAIL_TEST_ADDRESS"] || "defra-ruby-email@example.com"
    puts DefraRubyEmail::TestMailer.multipart_email(recipient, true).deliver_now
  end
end
