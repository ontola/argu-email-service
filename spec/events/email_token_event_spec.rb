# frozen_string_literal: true

require 'spec_helper'
require 'support/seeds'
require 'support/events_helper'
require 'support/test_root_id'

describe EmailTokenEvent, type: :model do
  let(:expected_sent_to) { 'test@email.com' }
  let(:expected_from) { 'Argu <noreply@argu.co>' }
  let(:expected_subject) { 'Uitnodiging voor Organization Name op Argu' }
  let(:expected_match) { 'Je bent uitgenodigd om lid te worden van de groep \'Group1\' van Organization Name' }

  let(:resource_id) { 'https://argu.dev/token/xxx' }
  let(:resource_type) { 'emailTokens' }
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
        group_id: 1,
        root_id: TEST_ROOT_ID
      }.merge(resource_attributes),
      changes: resource_changes
    )
  end

  context 'with email token without message and actor_iri' do
    let(:resource_attributes) do
      {
        email: 'test@email.com',
        message: '',
        actor_iri: nil,
        send_mail: true
      }
    end

    context 'when create' do
      let(:event_type) { 'create' }

      it_behaves_like 'has mail'
    end

    context 'when update' do
      let(:event_type) { 'update' }

      it_behaves_like 'no mail'
    end
  end

  context 'with email token with message and actor_iri' do
    let(:expected_from) { 'User1 <noreply@argu.co>' }
    let(:expected_match) { 'Hello world!' }

    let(:resource_attributes) do
      {
        email: 'test@email.com',
        message: 'Hello world!',
        actor_iri: argu_url('/argu/u/1'),
        send_mail: true
      }
    end

    context 'when create' do
      let(:event_type) { 'create' }

      it_behaves_like 'has mail'
    end

    context 'when update' do
      let(:event_type) { 'update' }

      it_behaves_like 'no mail'
    end
  end

  context 'with email token created with send_mail = false' do
    let(:resource_attributes) do
      {
        email: 'test@email.com',
        message: 'Hello world!',
        actor_iri: argu_url('/argu/u/1'),
        send_mail: false
      }
    end

    context 'when create' do
      let(:event_type) { 'create' }

      it_behaves_like 'no mail'
    end

    context 'when update' do
      let(:event_type) { 'update' }

      it_behaves_like 'no mail'
    end
  end

  context 'with bearer token created' do
    let(:resource_attributes) do
      {
        send_mail: true
      }
    end

    context 'when create' do
      let(:event_type) { 'create' }

      it_behaves_like 'no mail'
    end

    context 'when update' do
      let(:event_type) { 'update' }

      it_behaves_like 'no mail'
    end
  end
end
