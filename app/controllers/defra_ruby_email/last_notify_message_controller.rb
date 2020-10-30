# frozen_string_literal: true

module DefraRubyEmail
  class LastNotifyMessageController < ApplicationController
    def show
      LastNotifyMessage.instance.retrieve_last_notify_message

      render json: LastNotifyMessage.instance.last_notify_message_json
    end
  end
end
