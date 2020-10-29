# frozen_string_literal: true

module DefraRubyEmail
  class LastNotifyEmailController < ApplicationController
    def show
      render json: LastNotifyEmailCache.instance.last_notify_email_json
    end
  end
end
