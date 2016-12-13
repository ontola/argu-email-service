# frozen_string_literal: true
require 'sidekiq/api'

class Event < ApplicationRecord
  has_many :emails
  after_create :enqueue_job

  def enqueue_job
    if mailer.nil?
      update(processed_at: DateTime.current)
      return
    end
    return if job_is_active?
    ProcessEventJob.perform_async(id)
  end

  def mailer
    "#{resource_type}Mailer".safe_constantize
  end

  def desired_emails
    return @desired_emails unless @desired_emails.nil?
    @desired_emails = []
    initialize_desired_emails
    @desired_emails
  end

  private

  def add_desired_email(template, recipient)
    @desired_emails << {
      template: template,
      recipient: recipient
    }
  end

  def initialize_desired_emails
  end

  def job_is_active?
    return if job_id.nil?
    workers = Sidekiq::Workers.new
    workers.detect { |worker| worker[2]['payload']['jid'] == job_id }.present?
  end
end
