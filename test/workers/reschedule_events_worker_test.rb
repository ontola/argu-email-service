# frozen_string_literal: true
require 'test_helper'

class RescheduleEventsWorkerTest < ActiveSupport::TestCase
  let(:event) do
    create(:event,
           event: 'update',
           resource: 'http://argu.local/u/user1.json',
           resource_type: 'User',
           type: 'UserEvent',
           options: {
             encrypted_password: '[FILTERED]',
             updated_at: [1.day.ago, DateTime.current]
           },
           job_id: 'fewfwe')
  end
  let(:processed_event) do
    create(:event,
           event: 'update',
           resource: 'http://argu.local/u/user1.json',
           resource_type: 'User',
           type: 'UserEvent',
           options: {
             encrypted_password: '[FILTERED]',
             updated_at: [1.day.ago, DateTime.current]
           },
           processed_at: DateTime.current)
  end

  test 'should not reschedule processed event' do
    valid_user_mock(1)
    processed_event

    assert_no_difference 'Sidekiq::Worker.jobs.size' do
      RescheduleEventsWorker.new.perform
    end
  end

  test 'should reschedule unprocessed event' do
    valid_user_mock(1)
    event

    assert_difference 'Sidekiq::Worker.jobs.size', 1 do
      RescheduleEventsWorker.new.perform
    end
  end
end
