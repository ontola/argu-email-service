# frozen_string_literal: true
class ProcessBatchJob < ApplicationJob
  sidekiq_options retry: false, queue: 'email_service'

  def perform(batch_id)
    @batch = Batch.find_by(id: batch_id)
    return if @batch.nil? || @batch.processed_at

    @batch.with_lock do
      send_mails(@batch)

      @batch.update(processed_at: DateTime.current) unless @batch.emails.where(sent_at: nil).present?
    end
  end

  private

  def send_mails(batch)
    (batch.options.is_a?(Array) ? batch.options : [batch.options]).each { |options| send_mail(options) }
  end

  def send_mail(options)
    email = find_or_create_email(options)
    return if email.nil? || email.sent_at.present?

    r = @batch.mailer.send(@batch.method, email).deliver_now
    email.update(sent_at: DateTime.current, sent_to: email.recipient.email, mailgun_id: r.try(:message_id))
  end

  def find_or_create_email(options)
    find_email(options) || create_email(options)
  end

  def find_email(options)
    query = options.map { |key, value| value.map { |k, _v| "#{key} ->> '#{k}' = ?" } }.flatten.join(' AND ')
    query_values = options.map { |_key, value| value.map { |_k, v| v.to_s } }.flatten
    query_values << @batch.id.to_s
    Email.where("#{query} AND batch_id = ?", *query_values).take
  end

  def create_email(options)
    email = Email.new(options: options['options'], recipient: options['recipient'], batch_id: @batch.id)
    email.save ? email : nil
  end
end
