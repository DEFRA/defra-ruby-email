# frozen_string_literal: true

module DefraRubyEmail
  class LastEmailController < ApplicationController
    def show
      render json: LastEmailCache.instance.last_email_json
    end
  end
end
