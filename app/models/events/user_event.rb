# frozen_string_literal: true

class UserEvent < Event
  private

  def initialize_desired_emails
    case event
    when 'update'
      if changes.include?('encryptedPassword') && changes['hasPass']&.first != false
        add_desired_email(:password_changed, user, shortname: user.url)
      end
    end
  end

  def user
    @user ||= User.find(:one, from: URI(resource_id).path)
  end
end
