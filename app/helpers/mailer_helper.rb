# frozen_string_literal: true

module MailerHelper
  def recipient
    @record.recipient
  end

  def opts
    @record.options
  end

  def show_footer?
    @record.mailer.constantize.show_footer?
  end
end
