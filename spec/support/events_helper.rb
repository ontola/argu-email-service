# frozen_string_literal: true

RSpec.configure do |config|
  config.before do
    ActionMailer::Base.deliveries.clear
    group_mock(1)
    valid_user_mock(1)
  end

  shared_examples_for :no_mail do
    it 'sends no mail' do
      event

      assert_difference('ActionMailer::Base.deliveries.size', 0) do
        Sidekiq::Worker.drain_all
      end
    end
  end

  shared_examples_for :has_mail do
    it 'sends mail' do
      event

      assert_difference('ActionMailer::Base.deliveries.size', 1) do
        Sidekiq::Worker.drain_all
      end
      assert(Event.first.processed_at)
      assert(Email.last.sent_at)
      assert_equal Email.last.sent_to, expected_sent_to
      assert_equal ActionMailer::Base.deliveries.first.header['From'].value, expected_from
      assert_equal ActionMailer::Base.deliveries.first.subject, expected_subject
      assert_match expected_match,
                   ActionMailer::Base.deliveries.first.body.to_s
    end
  end
end
