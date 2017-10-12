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

  def set_password
    roadie_mail(to: recipient.email, subject: t('confirmations.set_password.subject'))
  end

  def confirm_votes
    roadie_mail(to: recipient.email, subject: t('confirmations.confirm_votes.subject', count: opts[:motions].count))
  end

  def self.show_footer?
    false
  end
end
