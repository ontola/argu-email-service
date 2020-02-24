# frozen_string_literal: true

RSpec.configure do |config|
  config.before do
    ActionMailer::Base.deliveries.clear
    group_mock(1)
    user_mock(1, root: 'argu', token: ENV['SERVICE_TOKEN'])
  end

  shared_examples_for 'no mail' do
    it 'sends no mail' do
      event

      assert_difference('ActionMailer::Base.deliveries.size', 0) do
        Sidekiq::Worker.drain_all
      end
    end
  end

  shared_examples_for 'has mail' do
    it 'sends mail' do
      event

      assert_difference('ActionMailer::Base.deliveries.size', 1) do
        Sidekiq::Worker.drain_all
      end
      assert(Event.first.processed_at)
      assert(EmailMessage.last.sent_at)
      assert_equal EmailMessage.last.sent_to, expected_sent_to
      assert_equal ActionMailer::Base.deliveries.first.header['From'].value, expected_from
      assert_equal ActionMailer::Base.deliveries.first.subject, expected_subject
      assert_match expected_match,
                   ActionMailer::Base.deliveries.first.body.to_s
    end
  end
end
