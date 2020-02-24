# frozen_string_literal: true

class ProcessEventJob < ApplicationJob
  sidekiq_options retry: false, queue: 'email_service'

  def perform(event_id)
    @event = Event.find_by(id: event_id)
    return if @event.nil? || @event.processed_at

    @event.desired_emails.each { |email| send_email(email) }
    return if @event.email_messages.present? && @event.email_messages.where('sent_at IS NOT NULL').empty?

    @event.update_columns(processed_at: Time.current, body: {})
  end

  private

  def send_email(opts)
    email = find_or_create_email(opts)
    return if email.nil? || email.sent_at.present?

    email.deliver_now
  end

  def find_or_create_email(opts)
    find_email(opts) || create_email(opts)
  end

  def find_email(opts)
    json_opts = opts.slice(:recipient, :options)
    json_opts[:recipient] = json_opts[:recipient].attributes
    query = json_opts.map { |key, value| value.map { |k, _v| "#{key} ->> '#{k}' = ?" } }.flatten.join(' AND ')
    query_values = json_opts.map { |_key, value| value.map { |_k, v| v.to_s } }.flatten
    @event.email_messages.where(query, *query_values).take
  end

  def create_email(opts)
    email = EmailMessage.new(
      event: @event,
      template: opts.delete(:template),
      recipient: opts.delete(:recipient),
      options: opts
    )
    email.save ? email : nil
  end
end
