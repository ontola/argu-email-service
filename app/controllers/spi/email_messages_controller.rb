# frozen_string_literal: true

module SPI
  class EmailMessagesController < ApplicationController
    skip_before_action :set_locale

    def create
      email = EmailMessage.new(permit_params)
      if email.save
        email.deliver_now
        head 201
      else
        render json_api_error(422, email.errors)
      end
    end

    private

    def permit_params
      p = params.require(:email).permit(:source_identifier, recipient: %i[display_name email id language])
      p[:template] = Template.find_by!(name: params[:email][:template])
      p[:options] = params[:email][:options]
      p.permit!
    end
  end
end
