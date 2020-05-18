# frozen_string_literal: true

class ExportEvent < Event
  private

  def initialize_desired_emails
    case event
    when 'update'
      case changes['status']&.second
      when 'failed'
        add_desired_email(:export_failed, user, export_opts)
      when 'done'
        add_desired_email(:export_done, user, export_opts)
      end
    end
  end

  def export_opts
    {
      download_url: resource[:relationships][:export_collection][:data][:id]
    }
  end

  def user
    @user ||= User.find(:one, from: URI(resource[:relationships][:user][:data][:id]).path)
  rescue OAuth2::Error => e
    raise e unless e.response.status == 404
  end
end
