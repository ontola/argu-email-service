# frozen_string_literal: true
require 'argu/whitelist_constraint'

Rails.application.routes.draw do
  constraints(Argu::WhitelistConstraint) do
    get '/emails', to: 'emails#index', defaults: {format: :json}
  end
  post '/email_events', to: 'email_events#create', defaults: {format: :json}

  constraints(Argu::WhitelistConstraint) do
    health_check_routes
  end
end
