# frozen_string_literal: true

DefraRubyEmail::Engine.routes.draw do
  get "/last-email",
      to: "last_email#show",
      as: "last_email",
      constraints: ->(_request) { DefraRubyEmail.configuration.enabled? }

  get "/last-notify-email",
      to: "last_notify_email#show",
      as: "last_notify_email",
      constraints: ->(_request) { DefraRubyEmail.configuration.enabled? }
end
