# frozen_string_literal: true
class UserMailer < ApplicationMailer
  def password_changed
    roadie_mail(to: recipient.email, subject: t('user.password_changed.subject'))
  end
end
