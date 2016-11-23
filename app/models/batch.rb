# frozen_string_literal: true
require 'sidekiq/api'

class Batch < ApplicationRecord
  has_many :emails
  after_create :enqueue_job
  validate :valid_template

  def enqueue_job
    return if job_is_active?
    ProcessBatchJob.perform_async(id)
  end

  def mailer
    Rails.configuration.templates[template][:mailer].constantize
  end

  def method
    Rails.configuration.templates[template][:method]
  end

  private

  def job_is_active?
    return if job_id.nil?
    workers = Sidekiq::Workers.new
    workers.detect { |worker| worker[2]['payload']['jid'] == job_id }.present?
  end

  def valid_template
    return if Rails.configuration.templates.keys.include?(template)
    errors.add(:template, 'Invalid template')
  end
end
