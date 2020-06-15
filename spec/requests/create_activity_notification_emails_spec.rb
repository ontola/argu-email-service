# frozen_string_literal: true

require 'spec_helper'
require 'support/seeds'

describe 'Create activity notification emails', type: :request do
  let(:organization_name) { 'Organization' }
  let(:organization2_name) { 'Organization 2' }
  let(:motion) { {display_name: 'Motion', id: argu_url('/m/1'), pro: nil, type: 'Motion'} }
  let(:creator) { {display_name: 'User', id: argu_url('/u/1'), thumbnail: argu_url('/thumbnail')} }
  let(:expected_from) { 'Page name <noreply@argu.co>' }
  let(:create_argument_notification) do
    {
      action: 'create',
      content: 'new argument',
      id: argu_url('/a/1'),
      display_name: 'Argument',
      pro: 'true',
      type: 'Argument',
      creator: creator
    }
  end
  let(:trash_motion_notification) do
    {
      action: 'trash',
      content: 'explanation',
      id: argu_url('/m/1'),
      display_name: 'Motion',
      pro: nil,
      type: 'Motion',
      creator: creator
    }
  end
  let(:forward_decision_notification) do
    {
      action: 'forwarded',
      content: 'new decision',
      id: argu_url('/d/1'),
      display_name: 'Decision',
      pro: nil,
      type: 'Decision',
      creator: creator
    }
  end
  let(:create_decision_notification) do
    {
      action: 'approved',
      content: 'new decision',
      id: argu_url('/d/1'),
      display_name: 'Decision',
      pro: nil,
      type: 'Decision',
      creator: creator
    }
  end

  shared_examples 'notification mailer' do |subject, *headers|
    let(:email_message) { EmailMessage.last }
    let(:email_delivery) { ActionMailer::Base.deliveries.last }

    it 'sends mail' do
      as_service
      assert_difference('ActionMailer::Base.deliveries.size', 1) do
        post '/argu/email/spi/emails',
             params: {
               email: {
                 template: 'activity_notifications',
                 recipient: {email: 'test@email.com', display_name: 'Recipient', language: NS::ARGU['language#en']},
                 options: {follows: follows}
               }
             }, headers: service_headers
        expect(response.code).to eq('201')
      end

      expect(email_message.sent_at).to be_truthy
      expect(email_message.sent_to).to eq('test@email.com')
      expect(email_delivery.to).to eq(['test@email.com'])
      expect(ActionMailer::Base.deliveries.first.header['From'].value).to eq(expected_from)
      expect(email_delivery.subject).to eq(subject)
      headers.each do |header|
        expect(email_delivery.body).to match(header)
      end
    end
  end

  context 'when one argument created' do
    let(:follows) do
      {
        '1': {
          notifications: [create_argument_notification],
          follow_id: argu_url('/follow/follow_id'),
          followable: motion,
          organization: {display_name: organization_name}
        }
      }
    end

    it_behaves_like 'notification mailer', "New argument in 'Motion'", 'A new argument is posted in'
  end

  context 'when two arguments created' do
    let(:follows) do
      {
        '1': {
          notifications: [create_argument_notification, create_argument_notification],
          follow_id: argu_url('/follow/follow_id'),
          followable: motion,
          organization: {display_name: organization_name}
        }
      }
    end

    it_behaves_like 'notification mailer', "New notifications in 'Motion'", 'New arguments are posted in'
  end

  context 'when two follows' do
    let(:follows) do
      {
        '1': {
          notifications: [create_argument_notification],
          follow_id: argu_url('/follow/follow_id'),
          followable: motion,
          organization: {display_name: organization_name}
        },
        '2': {
          notifications: [create_argument_notification],
          follow_id: argu_url('/follow/follow_id'),
          followable: motion,
          organization: {display_name: organization_name}
        }
      }
    end

    it_behaves_like 'notification mailer', "New notifications in 'Organization'", 'A new argument is posted in'
  end

  context 'when two organizations' do
    let(:follows) do
      {
        '1': {
          notifications: [create_argument_notification],
          follow_id: argu_url('/follow/follow_id'),
          followable: motion,
          organization: {display_name: organization_name}
        },
        '2': {
          notifications: [create_argument_notification],
          follow_id: argu_url('/follow/follow_id'),
          followable: motion,
          organization: {display_name: organization2_name}
        }
      }
    end
    let(:expected_from) { 'Argu <noreply@argu.co>' }

    it_behaves_like 'notification mailer', 'New Argu notifications', 'A new argument is posted in'
  end

  context 'when decision forwarded' do
    let(:follows) do
      {
        '1': {
          notifications: [forward_decision_notification],
          follow_id: argu_url('/follow/follow_id'),
          followable: motion,
          organization: {display_name: organization_name}
        }
      }
    end

    it_behaves_like 'notification mailer', "New notification in 'Motion'", 'is forwarded'
  end

  context 'when decision made' do
    let(:follows) do
      {
        '1': {
          notifications: [create_decision_notification],
          follow_id: argu_url('/follow/follow_id'),
          followable: motion,
          organization: {display_name: organization_name}
        }
      }
    end

    it_behaves_like 'notification mailer', "New decision in 'Motion'", 'is approved'
  end

  context 'when decision made and argument created' do
    let(:follows) do
      {
        '1': {
          notifications: [create_decision_notification, create_argument_notification],
          follow_id: argu_url('/follow/follow_id'),
          followable: motion,
          organization: {display_name: organization_name}
        }
      }
    end

    it_behaves_like 'notification mailer', "New notifications in 'Motion'", 'A new argument is posted in', 'is approved'
  end

  context 'when motion trashed' do
    let(:follows) do
      {
        '1': {
          notifications: [trash_motion_notification],
          follow_id: argu_url('/follow/follow_id'),
          followable: motion,
          organization: {display_name: organization_name}
        }
      }
    end

    it_behaves_like 'notification mailer', "New notification in 'Motion'", 'is deleted'
  end
end
