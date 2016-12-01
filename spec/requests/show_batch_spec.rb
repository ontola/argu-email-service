# frozen_string_literal: true
require 'rails_helper'

describe 'Show batch' do
  let!(:batch) do
    create(:batch,
           template: 'passwordChanged',
           caller_id: '_caller_id_',
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
    Email.last.events.create(event: 'delivered')

    get "/#{batch.caller_id}"
    expect(response.code).to eq('200')
    expect_included_size(3)
    expect_included_attributes_keys(['sent-to', 'sent-at', 'mailgun-id'])
    expect_included_attributes_keys(['created-at', 'event'], 2)
  end
end
