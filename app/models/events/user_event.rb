# frozen_string_literal: true

class UserEvent < Event
  private

  def initialize_desired_emails
    return if user.nil?
    case event
    when 'update'
      if changes.include?('encryptedPassword') && changes['hasPass']&.first != false
        add_desired_email(:password_changed, user, shortname: user.url)
      end
    end
  end

  def user
    @user ||= User.find(:one, from: URI(resource_id).path)
  rescue OAuth2::Error => e
    raise e unless e.response.status == 404
  end
end
