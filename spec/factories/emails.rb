# frozen_string_literal: true

FactoryGirl.define do
  factory :email_message do
    recipient { { id: 1 } }
    template { Template.first }
  end
end
