# frozen_string_literal: true

require 'spec_helper'
require 'support/seeds'

describe RescheduleEventsWorker, type: :model do
  it 'does not reschedule processed event' do
    user_mock(1)
    create(
      :event,
      event: 'update',
      resource_id: 'http://argu.local/u/1',
      resource_type: 'users',
      type: 'UserEvent',
      body: {
        changes: [
          {
            id: 'https://argu.local/u/1',
            type: 'users',
            attributes: {
              encryptedPassword: '[FILTERED]',
              updatedAt: [1.day.ago, Time.current]
            }
          }
        ]
      },
      processed_at: Time.current
    )

    assert_difference 'Sidekiq::Worker.jobs.size', 0 do
      described_class.new.perform
    end
  end

  it 'reschedules unprocessed event' do
    user_mock(1)
    find_tenant_mock('argu.local/u/1')

    create(
      :event,
      event: 'update',
      resource_id: 'http://argu.local/u/1',
      resource_type: 'users',
      type: 'UserEvent',
      body: {
        changes: [
          {
            id: 'https://argu.local/u/1',
            type: 'users',
            attributes: {
              encryptedPassword: '[FILTERED]',
              updatedAt: [1.day.ago, Time.current]
            }
          }
        ]
      },
      job_id: 'fewfwe'
    )

    assert_difference 'Sidekiq::Worker.jobs.size', 1 do
      described_class.new.perform
    end
  end
end
