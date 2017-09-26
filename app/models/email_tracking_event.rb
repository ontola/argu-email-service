# frozen_string_literal: true

class EmailTrackingEvent < ApplicationRecord
  belongs_to :email
end
