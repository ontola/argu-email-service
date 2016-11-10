# frozen_string_literal: true
require 'test_helper'

class PasswordChangedTest < ActiveSupport::TestCase
  test 'should create passwordChanged for user' do
    valid_user_mock(1)

    Batch.create(
      template: 'passwordChanged',
      options: {recipient: {type: 'user', id: 1}}
    )

    assert_difference('ActionMailer::Base.deliveries.size', 1) do
      Sidekiq::Worker.drain_all
    end
    assert(Batch.first.processed_at)
    assert(Email.last.sent_at)
    assert_equal Email.last.sent_to, 'user1@example.com'
    assert_equal ActionMailer::Base.deliveries.first.subject, 'Je wachtwoord is gewijzigd'
    assert_match 'We laten je weten dat je wachtwoord voor je Argu account "user1" gewijzigd is',
                 ActionMailer::Base.deliveries.first.body.encoded
  end

  test 'should create passwordChanged for multiple users' do
    valid_user_mock(1)
    valid_user_mock(2, 'en')

    Batch.create(
      template: 'passwordChanged',
      options:
        [
          {recipient: {type: 'user', id: 1}},
          {recipient: {type: 'user', id: 2}}
        ]
    )

    assert_difference('ActionMailer::Base.deliveries.size', 2) do
      Sidekiq::Worker.drain_all
    end

    assert(Email.first.sent_at)
    assert_equal Email.first.sent_to, 'user1@example.com'
    assert_equal ActionMailer::Base.deliveries.first.subject, 'Je wachtwoord is gewijzigd'
    assert(Email.last.sent_at)
    assert_equal Email.last.sent_to, 'user2@example.com'
    assert_equal ActionMailer::Base.deliveries.last.subject, 'Your password has been updated'
  end
end
