# frozen_string_literal: true

DefraRubyEmail::Engine.routes.draw do
  get "/test",
      to: "test#show",
      as: "test",
      constraints: ->(_request) { DefraRubyEmail.configuration.enabled? }
end
