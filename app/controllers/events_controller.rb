# frozen_string_literal: true
class EventsController < ApplicationController
  def show
    render json: Event.where(resource: params.fetch(:resource), event: params.fetch(:event)),
           include: ['emails', 'emails.email_events']
  end
end
