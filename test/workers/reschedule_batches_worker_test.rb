# frozen_string_literal: true
require 'test_helper'

class RescheduleBatchesWorkerTest < ActiveSupport::TestCase
  let(:batch) do
    create(:batch,
           template: 'passwordChanged',
           options: {recipient: {type: 'user', id: 1}},
           job_id: 'fewfwe')
  end
  let(:processed_batch) do
    create(:batch,
           template: 'passwordChanged',
           options: {recipient: {type: 'user', id: 1}},
           processed_at: DateTime.current)
  end

  test 'should not reschedule processed batch' do
    valid_user_mock(1)
    processed_batch

    assert_no_difference 'Sidekiq::Worker.jobs.size' do
      RescheduleBatchesWorker.new.perform
    end
  end

  test 'should reschedule unprocessed batch' do
    valid_user_mock(1)
    batch

    assert_difference 'Sidekiq::Worker.jobs.size', 1 do
      RescheduleBatchesWorker.new.perform
    end
  end
end
