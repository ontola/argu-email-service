# frozen_string_literal: true
class EmailsController < ApplicationController
  def index
    render json: Email.joins(:event).where(events: events_filter),
           include: :email_events
  end

  private

  def events_filter
    filter = {resource_id: params[:resource] || params[:resource_id]}
    filter[:resource_type] = params.fetch(:resource_type) unless params[:resource].present?
    filter[:event] = params[:event] if params[:event].present?
    filter
  end
end
