# frozen_string_literal: true
class RescheduleBatchesWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable
  sidekiq_options queue: 'email_service'

  recurrence { minutely }

  def perform
    Batch.where(processed_at: nil).each(&:enqueue_job)
  end
end
