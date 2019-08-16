# frozen_string_literal: true

require 'argu/whitelist_constraint'

Rails.application.routes.draw do
  scope :_public do
    scope :email do
      post '/email_events', to: 'email_tracking_events#create', defaults: {format: :json}
    end
  end
  scope :email do
    constraints(Argu::WhitelistConstraint) do
      get '/emails', to: 'email_messages#index', defaults: {format: :json}
    end

    constraints(Argu::WhitelistConstraint) do
      health_check_routes

      namespace :spi do
        post 'emails', to: 'email_messages#create', defaults: {format: :json}
      end
    end
  end
end
