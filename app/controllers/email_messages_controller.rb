# frozen_string_literal: true

class EmailMessagesController < ApplicationController
  def index
    render json: policy_scope(EmailMessage.joins(:event).where(events: events_filter)),
           include: :email_tracking_events
  end

  private

  def events_filter
    filter = {resource_id: params[:resource] || params[:resource_id]}
    filter[:resource_type] = params.fetch(:resource_type) if params[:resource].blank?
    filter[:event] = params[:event] if params[:event].present?
    filter
  end
end
