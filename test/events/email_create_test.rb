# frozen_string_literal: true
require 'test_helper'

class EmailCreateTest < ActiveSupport::TestCase
  test 'should mail when creating first email (registration)' do
    ActionMailer::Base.deliveries.clear
    valid_user_mock(1)

    create_email_event(
      attributes: {email: 'secondary_email@example.com', confirmationToken: 'confirmationToken', primary: true}
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

  def create_email_event(attrs)
    create_event(
      'create',
      'https://argu.local/u/user1/email/1',
      'emails',
      attributes: attrs[:attributes],
      changes: attrs[:changes],
      relationships: {user: {data: {id: 'https://argu.dev/u/user1', type: 'users'}}}
    )
  end
end
