# frozen_string_literal: true

require 'spec_helper'
require 'support/seeds'
require 'support/events_helper'

describe ExportEvent, type: :model do
  let(:expected_sent_to) { 'user1@example.com' }
  let(:expected_from) { 'Argu <noreply@argu.co>' }

  let(:event_type) { 'update' }
  let(:resource_id) { 'https://argu.dev/export/xxx' }
  let(:resource_type) { 'exports' }
  let(:resource_attributes) { {downloadUrl: argu_url('/download')} }
  let(:resource_relationships) do
    {user: {data: {id: argu_url('/u/user1')}}, exportCollection: {data: {id: argu_url('/exports')}}}
  end

  let(:event) do
    create_event(
      event_type,
      resource_id,
      resource_type,
      attributes: resource_attributes,
      relationships: resource_relationships,
      changes: resource_changes
    )
  end

  context 'when export done' do
    let(:resource_changes) { {status: %w[processing done]} }
    let(:expected_subject) { 'Export beschikbaar' }
    let(:expected_match) { 'De door jouw aangevraagde export is beschikbaar' }

    it_behaves_like :has_mail
  end

  context 'when export failed' do
    let(:resource_changes) { {status: %w[processing failed]} }
    let(:expected_subject) { 'Export mislukt' }
    let(:expected_match) { 'De door jouw aangevraagde export is mislukt' }

    it_behaves_like :has_mail
  end
end
