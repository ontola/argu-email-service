# frozen_string_literal: true

require 'test_helper'

class EmailAddressCreateTest < ActiveSupport::TestCase
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
    assert_equal Email.last.mailer, 'EmailAddressMailer'
    assert_equal ActionMailer::Base.deliveries.first.subject, 'Bevestig jouw e-mailadres'
  end

  test 'should not mail when no confirmation_token present' do
    ActionMailer::Base.deliveries.clear
    valid_user_mock(1)

    create_email_event(
      attributes: {email: 'secondary_email@example.com', confirmationToken: nil, primary: true}
    )

    assert_difference('ActionMailer::Base.deliveries.size', 0) do
      Sidekiq::Worker.drain_all
    end
  end

  test 'should mail when adding secondary email' do
    ActionMailer::Base.deliveries.clear
    valid_user_mock(1)

    create_email_event(
      attributes: {email: 'secondary_email@example.com', confirmationToken: 'confirmationToken', primary: false}
    )

    assert_difference('ActionMailer::Base.deliveries.size', 1) do
      Sidekiq::Worker.drain_all
    end
    assert(Event.first.processed_at)
    assert(Email.last.sent_at)
    assert_equal Email.last.sent_to, 'secondary_email@example.com'
    assert_equal Email.last.mailer, 'EmailAddressMailer'
    assert_equal ActionMailer::Base.deliveries.first.subject, 'Voeg jouw e-mailadres toe'
  end

  private

  def create_email_event(attrs)
    create_event(
      'create',
      'https://argu.local/u/user1/email/1',
      'emailAddresses',
      attributes: attrs[:attributes],
      changes: attrs[:changes],
      relationships: {user: {data: {id: 'https://argu.dev/u/user1', type: 'users'}}}
    )
  end
end
