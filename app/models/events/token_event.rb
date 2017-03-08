# frozen_string_literal: true
class TokenEvent < Event
  def group
    Group.find(resource['groupId'])
  end

  private

  def initialize_desired_emails
    case event
    when 'create'
      if resource['email'].present? && resource['sendMail'] == true
        add_desired_email(:email_token_created, User.new(email: resource['email'], language: 'nl'))
      end
    end
  end
end
