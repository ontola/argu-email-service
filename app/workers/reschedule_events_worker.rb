# frozen_string_literal: true

class RescheduleEventsWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'email_service'

  def perform
    Apartment::Tenant.each do
      Event.where(processed_at: nil).find_each do |event|
        ActsAsTenant.with_tenant(TenantFinder.from_url(event.resource_id)) { event.enqueue_job }
      end
    end
  end
end
