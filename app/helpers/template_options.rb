# frozen_string_literal: true

module TemplateOptions
  include ActivityNotificationHelper

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

  def activity_notifications_opts
    organizations = activity_follows.map(&:organization).uniq
    return {subject_key: 'templates.activity_notifications.subject.argu'} if organizations.count > 1
    if activity_follows.count == 1
      activity_notification_one_follow_opts
    else
      activity_notification_multi_follow_opts(organizations.first)
    end
  end
end
