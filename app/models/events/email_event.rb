# frozen_string_literal: true
class EmailEvent < Event
  private

  def initialize_desired_emails
    case event
    when 'update'
      add_confirmation_request_mail if changes.include? 'confirmationSentAt'
    when 'create'
      return if resource['confirmationToken'].nil?
      resource['primary'] ? add_confirmation_mail : add_confirm_secondary_mail
    end
  end

  def add_confirmation_mail
    add_desired_email(
      :confirmation,
      User.find(:one, from: URI(resource[:relationships][:user][:data][:id]).path)
    )
  end

  def add_confirm_secondary_mail
    add_desired_email(
      :confirm_secondary,
      User.find(:one, from: URI(resource[:relationships][:user][:data][:id]).path)
    )
  end

  def add_confirmation_request_mail
    add_desired_email(
      :requested_confirmation,
      User.find(:one, from: URI(resource[:relationships][:user][:data][:id]).path)
    )
  end
end
