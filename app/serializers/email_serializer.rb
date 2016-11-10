# frozen_string_literal: true
class EmailSerializer < ActiveModel::Serializer
  attributes :id, :sent_to, :sent_at, :mailgun_id
  has_many :events
end
