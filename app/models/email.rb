# frozen_string_literal: true
class Email < ApplicationRecord
  has_many :email_events
  belongs_to :event

  def recipient
    @recipient ||= User.new(attributes['recipient'])
  end
end
