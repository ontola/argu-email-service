# frozen_string_literal: true
require 'rails_helper'

describe 'Create event' do
  let!(:batch) do
    create(:batch,
           caller_id: '_caller_id_',
           template: 'passwordChanged',
           options: [
             {recipient: {type: 'user', id: 1}},
             {recipient: {type: 'user', id: 2}}
           ],
           job_id: '_job_id_')
  end

  it 'should get batch with send emails' do
    valid_user_mock(1)
    valid_user_mock(2)
    Sidekiq::Worker.drain_all

    post '/events', params: {
      'argu-mail-id': Email.last.id,
      recipient: Email.last.sent_to,
      event: 'clicked'
    }
    expect(response.code).to eq('200')
  end
end
