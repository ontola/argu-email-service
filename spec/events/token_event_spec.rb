# frozen_string_literal: true

require 'spec_helper'
require 'support/seeds'
require 'support/events_helper'

describe TokenEvent, type: :model do
  let(:expected_sent_to) { 'test@example.com' }
  let(:expected_from) { 'Argu <noreply@argu.co>' }
  let(:expected_subject) { 'Uitnodiging voor Argu op Argu' }
  let(:expected_match) { 'Je bent uitgenodigd om lid te worden van de groep \'Group1\' van Argu' }

  let(:resource_id) { 'https://argu.dev/token/xxx' }
  let(:resource_type) { 'tokens' }
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

  context 'with email token without message and actor_iri' do
    let(:resource_attributes) do
      {
        email: 'test@example.com',
        message: '',
        actorIRI: nil,
        sendMail: true
      }
    end

    context 'when create' do
      let(:event_type) { 'create' }

      it_behaves_like :has_mail
    end

    context 'when update' do
      let(:event_type) { 'update' }

      it_behaves_like :no_mail
    end
  end

  context 'with email token with message and actor_iri' do
    let(:expected_from) { 'User1 <noreply@argu.co>' }
    let(:expected_match) { 'Hello world!' }

    let(:resource_attributes) do
      {
        email: 'test@example.com',
        message: 'Hello world!',
        actorIRI: argu_url('/u/user1'),
        sendMail: true
      }
    end

    context 'when create' do
      let(:event_type) { 'create' }

      it_behaves_like :has_mail
    end

    context 'when update' do
      let(:event_type) { 'update' }

      it_behaves_like :no_mail
    end
  end

  context 'with email token created with send_mail = false' do
    let(:resource_attributes) do
      {
        email: 'test@example.com',
        message: 'Hello world!',
        actorIRI: argu_url('/u/user1'),
        sendMail: false
      }
    end

    context 'when create' do
      let(:event_type) { 'create' }

      it_behaves_like :no_mail
    end

    context 'when update' do
      let(:event_type) { 'update' }

      it_behaves_like :no_mail
    end
  end

  context 'with bearer token created' do
    let(:resource_attributes) do
      {
        sendMail: true
      }
    end

    context 'when create' do
      let(:event_type) { 'create' }

      it_behaves_like :no_mail
    end

    context 'when update' do
      let(:event_type) { 'update' }

      it_behaves_like :no_mail
    end
  end
end
