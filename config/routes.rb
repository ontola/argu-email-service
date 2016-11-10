# frozen_string_literal: true
Rails.application.routes.draw do
  get '/:id', to: 'batches#show', defaults: {format: :json}
  post '/events', to: 'events#create', defaults: {format: :json}
end
