# frozen_string_literal: true
class EmailMailer < ApplicationMailer
  def confirmation
    roadie_mail(to: recipient.email, subject: t('email.confirmation.subject'))
  end

  def self.show_footer?
    false
  end
end
