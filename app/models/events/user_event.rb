# frozen_string_literal: true
class UserEvent < Event
  private

  def initialize_desired_emails
    case event
    when 'update'
      if changes.include? 'encryptedPassword'
        add_desired_email(:password_changed, User.find(:one, from: URI(resource_id).path))
      end
    end
  end
end
