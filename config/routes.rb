# frozen_string_literal: true

Rails.application.routes.draw do
  scope :_public do
    post '/email_events', to: 'email_tracking_events#create', defaults: {format: :json}
  end

  constraints(LinkedRails::Constraints::Whitelist) do
    get '/emails', to: 'email_messages#index', defaults: {format: :json}
  end

  constraints(LinkedRails::Constraints::Whitelist) do
    health_check_routes

    namespace :spi do
      post 'emails', to: 'email_messages#create', defaults: {format: :json}
    end
  end
end
