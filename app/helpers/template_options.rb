# frozen_string_literal: true

module TemplateOptions
  def confirm_secondary_opts
    {to: options[:email]}
  end

  def requested_confirmation_opts
    {to: options[:email]}
  end

  def confirm_votes_opts
    {subject_opts: {count: options[:motions].count}}
  end

  def email_token_created_opts
    {
      from: "#{options[:profile].try(:[], :display_name) || 'Argu'} <noreply@argu.co>",
      subject_opts: {organization: options[:organization_name]}
    }
  end
end
