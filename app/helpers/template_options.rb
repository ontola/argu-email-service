# frozen_string_literal: true

module TemplateOptions
  include ActivityNotificationHelper

  def confirm_secondary_opts
    {to: options[:email]}
  end

  def direct_message_opts
    {
      from: "#{options[:actor][:display_name]} <noreply@argu.co>",
      subject: options[:subject],
      reply_to: options[:email]
    }
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
      subject_opts: {organization: ActsAsTenant.current_tenant.display_name}
    }
  end

  def activity_notifications_opts
    organizations = activity_follows.map(&:organization).uniq

    if activity_follows.count == 1
      activity_notification_one_follow_opts
    elsif organizations.count == 1
      activity_notification_multi_follow_opts(organizations.first)
    else
      activity_notification_multi_organization_opts
    end
  end
end
