# frozen_string_literal: true
class Email < ApplicationRecord
  has_many :events
  belongs_to :batch

  def recipient
    @recipient ||= if attributes['recipient']['type'] == 'user'
                     User.find(attributes['recipient']['id'])
                   else
                     user_from_attributes
                   end
  end

  private

  def user_from_attributes
    User.new({email: attributes['recipient']['id'], language: 'en'}
               .merge(attributes['recipient']['attributes'] || {}))
  end
end
