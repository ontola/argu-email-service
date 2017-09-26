# frozen_string_literal: true

class EmailMailer < ApplicationMailer
  def confirmation
    roadie_mail(to: recipient.email, subject: t('email.confirmation.subject'))
  end

  def confirm_secondary
    roadie_mail(to: event.resource['email'], subject: t('email.confirm_secondary.subject'))
  end

  def requested_confirmation
    roadie_mail(to: recipient.email, subject: t('email.requested_confirmation.subject'))
  end

  def self.show_footer?
    false
  end
end
