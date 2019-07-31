# frozen_string_literal: true

class RescheduleEventsWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable
  sidekiq_options queue: 'email_service'

  recurrence { minutely }

  def perform
    Apartment::Tenant.each do
      Event.where(processed_at: nil).each(&:enqueue_job)
    end
  end
end
