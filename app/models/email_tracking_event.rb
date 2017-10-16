# frozen_string_literal: true

class EmailTrackingEvent < ApplicationRecord
  belongs_to :email_message, foreign_key: :email_id
end
