# frozen_string_literal: true
require 'test_helper'

class UserUpdateTest < ActiveSupport::TestCase
  test 'should mail when password changed' do
    valid_user_mock(1)

    Event.create(
      event: 'update',
      resource_id: 'https://argu.local/u/user1',
      resource_type: 'User',
      type: 'UserEvent',
      options: {
        encrypted_password: '[FILTERED]',
        updated_at: [1.day.ago, DateTime.current]
      }
    )

    assert_difference('ActionMailer::Base.deliveries.size', 1) do
      Sidekiq::Worker.drain_all
    end
    assert(Event.first.processed_at)
    assert(Email.last.sent_at)
    assert_equal Email.last.sent_to, 'user1@example.com'
    assert_equal ActionMailer::Base.deliveries.first.subject, 'Je wachtwoord is gewijzigd'
    assert_match 'We laten je weten dat je wachtwoord voor je Argu account "user1" gewijzigd is',
                 ActionMailer::Base.deliveries.first.body.encoded
  end

  test 'should not mail when logged in' do
    valid_user_mock(1)

    Event.create(
      event: 'update',
      resource_id: 'https://argu.local/u/user1',
      resource_type: 'User',
      type: 'UserEvent',
      options: {
        current_sign_in_at: [1.day.ago, DateTime.current],
        last_sign_in_at: [2.days.ago, 1.day.ago],
        sign_in_count: [10, 11],
        updated_at: [1.day.ago, DateTime.current]
      }
    )

    assert_difference('ActionMailer::Base.deliveries.size', 0) do
      Sidekiq::Worker.drain_all
    end
  end
end
