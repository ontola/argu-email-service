# frozen_string_literal: true

class Template < ApplicationRecord
  has_many :email_messages
end
