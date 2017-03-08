# frozen_string_literal: true
class TokenMailer < ApplicationMailer
  def email_token_created
    roadie_mail(to: recipient.email, subject: t('tokens.email_token_created.subject'))
  end
end
