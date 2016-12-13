# frozen_string_literal: true
Rails.application.routes.draw do
  get '/events', to: 'events#show', defaults: {format: :json}
  post '/email_events', to: 'email_events#create', defaults: {format: :json}
end
