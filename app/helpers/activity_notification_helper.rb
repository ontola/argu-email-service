# frozen_string_literal: true

module ActivityNotificationHelper
  def activity_follows
    @activity_follows ||= options[:follows].map { |_k, f| Struct::Follow.new(*f.values_at(*Struct::Follow.members)) }
  end

  def activity_notification_one_follow_opts
    follow = activity_follows.first
    type = follow.notifications.count == 1 ? follow_subject_type(follow) : t('models.new_plural.notification')
    {
      'List-Unsubscribe': "<#{follow.follow_id}>",
      'List-Unsubscribe-Post': 'List-Unsubscribe=One-Click',
      subject_key: 'templates.activity_notifications.subject.recipient',
      subject_opts: {type: type, recipient: follow.followable[:display_name]}
    }
  end

  def activity_notification_multi_follow_opts(recipient)
    {
      subject_key: 'templates.activity_notifications.subject.recipient',
      subject_opts: {type: t('models.new_plural.notification'), recipient: recipient[:display_name]}
    }
  end

  def activity_notification_multi_organization_opts
    {
      subject_key: 'templates.activity_notifications.subject.argu',
      from: ApplicationMailer.default_params[:from]
    }
  end

  def follow_subject_type(follow)
    notification = follow.notifications.first
    case notification_group(notification)
    when 'reaction'
      t("models.new.#{notification[:type].underscore}", default: t('models.new.default'))
    when 'decision'
      notification[:action] == 'forwarded' ? t('models.new.notification') : t('models.new.decision')
    else
      t('models.new.notification')
    end
  end

  def new_reactions_header(notifications)
    types = notifications.map { |n| n[:type] }.uniq
    type = types.count == 1 ? types.first.underscore : 'default'
    t(
      'templates.activity_notifications.new_reactions',
      count: notifications.count,
      type: t("models.#{notifications.count == 1 ? 'new' : 'new_plural'}.#{type}", default: t('models.new.default'))
    ).capitalize
  end

  def notification_group(notification)
    return 'decision' if notification[:type] == 'Decision'
    return notification[:action] if notification[:action] == 'trash'

    'reaction'
  end

  def notifications_group(follow, type)
    {
      follow_id: follow.follow_id,
      followable: follow.followable,
      notifications: follow.notifications.select { |n| notification_group(n) == type }
    }
  end

  def type_class(object)
    return "#{object[:pro].to_s == 'true' ? 'pro' : 'con'}-t" unless object[:pro].nil?

    "#{object[:type].underscore}-t"
  end
end
