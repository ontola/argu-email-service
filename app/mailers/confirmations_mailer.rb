# frozen_string_literal: true

class ConfirmationsMailer < ApplicationMailer
  def confirmation
    roadie_mail(to: recipient.email, subject: t('confirmations.confirmation.subject'))
  end

  def confirm_secondary
    roadie_mail(to: opts[:email], subject: t('confirmations.confirm_secondary.subject'))
  end

  def requested_confirmation
    roadie_mail(to: opts[:email], subject: t('confirmations.requested_confirmation.subject'))
  end

  def self.show_footer?
    false
  end
end
