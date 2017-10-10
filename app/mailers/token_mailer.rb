# frozen_string_literal: true

class TokenMailer < ApplicationMailer
  def email_token_created
    roadie_mail(
      to: recipient.email,
      from: "#{opts[:profile].try(:[], :display_name) || 'Argu'} <noreply@argu.co>",
      subject: t('tokens.email_token_created.subject', organization: opts[:organization_name])
    )
  end

  def self.show_footer?
    false
  end
end
