# frozen_string_literal: true

require 'test_helper'

class EmailUpdateTest < ActiveSupport::TestCase
  test 'should mail when confirmationSentAt changed' do
    ActionMailer::Base.deliveries.clear
    valid_user_mock(1)

    update_email_event(
      attributes: {
        confirmationToken: 'confirmationToken',
        email: 'secondary_email@example.com',
        primary: true
      },
      changes: {confirmationSentAt: [1.day.ago, DateTime.current]}
    )

    assert_difference('ActionMailer::Base.deliveries.size', 1) do
      Sidekiq::Worker.drain_all
    end
    assert(Event.first.processed_at)
    assert(Email.last.sent_at)
    assert_equal Email.last.sent_to, 'user1@example.com'
    assert_equal ActionMailer::Base.deliveries.first.subject, 'Bevestig jouw e-mailadres'
  end

  private

  def update_email_event(attrs)
    create_event(
      'update',
      'https://argu.local/u/user1/email/1',
      'emails',
      attributes: attrs[:attributes],
      changes: attrs[:changes],
      relationships: {user: {data: {id: 'https://argu.dev/u/user1', type: 'users'}}}
    )
  end
end
