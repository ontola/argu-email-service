# frozen_string_literal: true

require 'spec_helper'
require 'support/seeds'

describe RescheduleEventsWorker, type: :model do
  it 'does not reschedule processed event' do
    valid_user_mock(1)
    create(
      :event,
      event: 'update',
      resource_id: 'http://argu.local/u/user1',
      resource_type: 'users',
      type: 'UserEvent',
      body: {
        changes: [
          {
            id: 'https://argu.local/u/user1',
            type: 'users',
            attributes: {
              encryptedPassword: '[FILTERED]',
              updatedAt: [1.day.ago, DateTime.current]
            }
          }
        ]
      },
      processed_at: DateTime.current
    )

    assert_difference 'Sidekiq::Worker.jobs.size', 0 do
      RescheduleEventsWorker.new.perform
    end
  end

  it 'reschedules unprocessed event' do
    valid_user_mock(1)

    create(
      :event,
      event: 'update',
      resource_id: 'http://argu.local/u/user1',
      resource_type: 'users',
      type: 'UserEvent',
      body: {
        changes: [
          {
            id: 'https://argu.local/u/user1',
            type: 'users',
            attributes: {
              encryptedPassword: '[FILTERED]',
              updatedAt: [1.day.ago, DateTime.current]
            }
          }
        ]
      },
      job_id: 'fewfwe'
    )

    assert_difference 'Sidekiq::Worker.jobs.size', 1 do
      RescheduleEventsWorker.new.perform
    end
  end
end
