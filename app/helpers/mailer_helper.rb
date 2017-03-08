# frozen_string_literal: true
module MailerHelper
  def recipient
    @record.recipient
  end

  def resource
    @record.event.resource
  end
end
