# frozen_string_literal: true

require 'test_helper'

class UserUpdateTest < ActiveSupport::TestCase
  test 'should mail when password changed' do
    ActionMailer::Base.deliveries.clear
    valid_user_mock(1)

    update_user_event(changes: {encryptedPassword: '[FILTERED]', updatedAt: [1.day.ago, DateTime.current]})

    assert_difference('ActionMailer::Base.deliveries.size', 1) do
      Sidekiq::Worker.drain_all
    end
    assert(Event.first.processed_at)
    assert(Email.last.sent_at)
    assert_equal Email.last.sent_to, 'user1@example.com'
    assert_equal ActionMailer::Base.deliveries.first.subject, 'Je wachtwoord is gewijzigd'
    assert_match 'We laten je weten dat je wachtwoord voor je Argu account "user1" gewijzigd is',
                 ActionMailer::Base.deliveries.first.body.to_s
  end

  test 'should not mail when logged in' do
    valid_user_mock(1)

    update_user_event(
      changes: {
        currentSignInAt: [1.day.ago, DateTime.current],
        lastSignInAt: [2.days.ago, 1.day.ago],
        signInCount: [10, 11],
        updatedAt: [1.day.ago, DateTime.current]
      }
    )

    assert_difference('ActionMailer::Base.deliveries.size', 0) do
      Sidekiq::Worker.drain_all
    end
  end

  private

  def update_user_event(attrs)
    create_event(
      'update',
      'https://argu.local/u/user1',
      'users',
      attributes: attrs[:attributes],
      changes: attrs[:changes]
    )
  end
end
