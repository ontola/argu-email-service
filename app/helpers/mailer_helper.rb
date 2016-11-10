# frozen_string_literal: true
module MailerHelper
  def recipient
    @record.recipient
  end

  def options(_key)
    @record.options[:key]
  end
end
