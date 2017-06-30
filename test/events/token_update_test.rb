# frozen_string_literal: true
require 'test_helper'

class TokenUpdateTest < ActiveSupport::TestCase
  test 'should not mail when email token changed' do
    group_mock(1)
    valid_user_mock(1)

    update_token_event(
      attributes: {
        usages: 0,
        createdAt: DateTime.current,
        expiresAt: nil,
        retractedAt: nil,
        email: 'test@example.com',
        sendMail: true,
        groupId: 1
      }
    )
    assert_difference('ActionMailer::Base.deliveries.size', 0) do
      Sidekiq::Worker.drain_all
    end
  end

  private

  def update_token_event(attrs)
    create_event(
      'update',
      'https://argu.dev/token/xxx',
      'tokens',
      attributes: attrs[:attributes],
      changes: attrs[:changes]
    )
  end
end
