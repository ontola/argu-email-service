# frozen_string_literal: true
class EmailEvent < Event
  private

  def initialize_desired_emails
    case event
    when 'create'
      add_confirmation_mail if resource['primary']
    end
  end

  def add_confirmation_mail
    add_desired_email(
      :confirmation,
      User.find(:one, from: URI(resource[:relationships][:user][:data][:id]).path)
    )
  end
end
