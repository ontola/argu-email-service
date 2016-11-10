# frozen_string_literal: true
class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found

  private

  def argu_client
    @argu_client ||= OAuth2::Client.new(
      ENV['ARGU_APP_ID'],
      ENV['ARGU_APP_SECRET'],
      site: ENV['OAUTH_URL'],
      raise_errors: false
    )
  end

  def argu_token
    @argu_token ||= OAuth2::AccessToken.new(argu_client, ENV['CLIENT_TOKEN'])
  end

  def handle_record_not_found
    respond_to do |format|
      format.html { send_file 'public/404.html', disposition: :inline, status: 404 }
      format.json { render json_api_error(404, 'Please provide a valid token') }
    end
  end

  # @param [Integer] status HTML response code
  # @param [Array<Hash, String>] errors A list of errors
  # @return [Hash] JSONApi error hash to use in a render method
  def json_api_error(status, *errors)
    errors = errors.map do |error|
      if error.is_a?(Hash)
        {type: Rack::Utils::HTTP_STATUS_CODES[status]}.merge(error)
      else
        {type: Rack::Utils::HTTP_STATUS_CODES[status], message: error.is_a?(Hash) ? error[:message] : error}
      end
    end
    {json: {errors: errors}, status: status}
  end
end
