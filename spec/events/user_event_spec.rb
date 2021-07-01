# frozen_string_literal: true

require 'spec_helper'
require 'support/seeds'
require 'support/events_helper'

describe UserEvent, type: :model do
  let(:expected_sent_to) { 'user1@email.com' }
  let(:expected_from) { 'Argu <noreply@argu.co>' }
  let(:expected_subject) { 'Your password has been updated' }
  let(:expected_match) { 'We\'re letting you know that the password for your account has been updated' }

  let(:resource_id) { 'https://argu.local/argu/u/1' }
  let(:resource_type) { 'users' }
  let(:resource_attributes) { {} }
  let(:resource_changes) { {} }

  let(:event) do
    create_event(
      event_type,
      resource_id,
      resource_type,
      attributes: {
        usages: 0,
        created_at: Time.current,
        expires_at: nil,
        retracted_at: nil,
        group_id: 1
      }.merge(resource_attributes),
      changes: resource_changes
    )
  end

  context 'when changing password' do
    let(:resource_changes) do
      {encrypted_password: '[FILTERED]', updated_at: [1.day.ago, Time.current]}
    end

    context 'when update' do
      let(:event_type) { 'update' }

      it_behaves_like 'has mail'
    end

    context 'when user destroyed' do
      let(:event_type) { 'update' }
      let(:resource_id) do
        not_found_mock(expand_service_url(:argu, '/argu/u/destroyed'))
        argu_url('/argu/u/destroyed')
      end

      it_behaves_like 'no mail'
    end
  end

  context 'when logging in' do
    let(:resource_changes) do
      {
        current_sign_in_at: [1.day.ago, Time.current],
        last_sign_in_at: [2.days.ago, 1.day.ago],
        sign_in_count: [10, 11],
        updated_at: [1.day.ago, Time.current]
      }
    end

    context 'when update' do
      let(:event_type) { 'update' }

      it_behaves_like 'no mail'
    end
  end
end
