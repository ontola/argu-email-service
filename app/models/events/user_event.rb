# frozen_string_literal: true

class UserEvent < Event
  private

  def initialize_desired_emails
    return if user.nil?

    case event
    when 'update'
      if changes.include?('encrypted_password') && changes['has_pass']&.first != false
        add_desired_email(:password_changed, user)
      end
    end
  end

  def user
    @user ||= User.find(:one, from: URI(resource_id).path)
  rescue ActiveResource::ResourceNotFound
    nil
  end
end
