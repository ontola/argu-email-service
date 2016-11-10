# frozen_string_literal: true
class BatchSerializer < ActiveModel::Serializer
  attributes :id
  has_many :emails
end
