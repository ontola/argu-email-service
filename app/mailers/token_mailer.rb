# frozen_string_literal: true
class TokenMailer < ApplicationMailer
  include TokenHelper
  add_template_helper(TokenHelper)

  def email_token_created
    roadie_mail(
      to: recipient.email,
      from: "#{profile&.display_name || 'Argu'} <noreply@argu.co>",
      subject: t('tokens.email_token_created.subject', organization: organization.display_name)
    )
  end

  def self.show_footer?
    false
  end
end
