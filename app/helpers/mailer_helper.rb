# frozen_string_literal: true
module MailerHelper
  def recipient
    @record.recipient
  end

  def resource
    @record.event.resource
  end

  def show_footer?
    @record.event.mailer.show_footer?
  end
end
