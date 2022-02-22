# frozen_string_literal: true

class EmailTokenEvent < Event
  private

  def group
    @group ||= Group.find(resource[:group_id])
  end

  def profile
    @profile ||= ActiveResourceModel.find(:one, from: resource[:actor_iri])
  end

  def initialize_desired_emails
    case event
    when 'create'
      if resource[:email].present? && resource[:send_mail] == true
        add_desired_email(
          :email_token_created,
          User.new(email: resource[:email], language: 'nl'),
          email_token_created_opts
        )
      end
    end
  end

  def email_token_created_opts
    {
      iri: resource[:id],
      message: resource[:message],
      group_name: group.display_name,
      organization_name: ActsAsTenant.current_tenant.display_name,
      profile: profile_opts
    }
  end

  def profile_opts
    {
      id: profile&.id,
      profile_photo_thumbnail: profile&.default_profile_photo&.thumbnail,
      display_name: profile&.display_name
    }
  end
end
