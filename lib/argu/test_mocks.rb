# frozen_string_literal: true
module TestMocks
  include UrlHelper

  def valid_user_mock(id, language = 'nl')
    stub_request(:get, argu_url("/u/user#{id}"))
      .to_return(
        status: 200,
        headers: {'Content-Type' => 'application/json'},
        body: {
          data: {
            id: id,
            type: 'users',
            attributes: {
              display_name: "User#{id}",
              url: "user#{id}",
              email: "user#{id}@example.com",
              language: language
            }
          }
        }.to_json
      )
  end

  private

  def host_name
    Rails.application.config.host_name
  end
end
