# frozen_string_literal: true

require 'spec_helper'
require 'support/seeds'
require 'support/events_helper'

describe UserEvent, type: :model do
  let(:expected_sent_to) { 'user1@example.com' }
  let(:expected_from) { 'Argu <noreply@argu.co>' }
  let(:expected_subject) { 'Je wachtwoord is gewijzigd' }
  let(:expected_match) { 'We laten je weten dat je wachtwoord voor je Argu account "user1" gewijzigd is' }

  let(:resource_id) { 'https://argu.local/u/user1' }
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
        createdAt: Time.current,
        expiresAt: nil,
        retractedAt: nil,
        groupId: 1
      }.merge(resource_attributes),
      changes: resource_changes
    )
  end

  context 'when changing password' do
    let(:resource_changes) do
      {encryptedPassword: '[FILTERED]', updatedAt: [1.day.ago, Time.current]}
    end

    context 'when update' do
      let(:event_type) { 'update' }

      it_behaves_like :has_mail
    end

    context 'when user destroyed' do
      let(:event_type) { 'update' }
      let(:resource_id) do
        not_found_mock(expand_service_url(:argu, '/u/destroyed'))
        argu_url('/u/destroyed')
      end

      it_behaves_like :no_mail
    end
  end

  context 'when logging in' do
    let(:resource_changes) do
      {
        currentSignInAt: [1.day.ago, Time.current],
        lastSignInAt: [2.days.ago, 1.day.ago],
        signInCount: [10, 11],
        updatedAt: [1.day.ago, Time.current]
      }
    end

    context 'when update' do
      let(:event_type) { 'update' }

      it_behaves_like :no_mail
    end
  end
end
