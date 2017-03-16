# frozen_string_literal: true
require 'argu/whitelist_constraint'

Rails.application.routes.draw do
  get '/events', to: 'events#show', defaults: {format: :json}
  post '/email_events', to: 'email_events#create', defaults: {format: :json}

  constraints(Argu::WhitelistConstraint) do
    health_check_routes
  end
end
