# frozen_string_literal: true

module SPI
  class EmailsController < ApplicationController
    def create
      email = Email.new(permit_params)
      if email.save
        email.deliver_now
        head 201
      else
        render json_api_error(422, email.errors)
      end
    end

    private

    def permit_params
      p = params.require(:email).permit(:mailer, :template, recipient: %i[display_name email id language])
      p[:options] = params[:email][:options]
      p.permit!
    end
  end
end
