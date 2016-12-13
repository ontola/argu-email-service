# frozen_string_literal: true
module TestMocks
  def valid_user_mock(id, language = 'nl')
    stub_request(:get, "#{host_name}/u/user#{id}.json")
      .to_return(
        status: 200,
        headers: {'Content-Type' => 'application/json'},
        body: {
          data: {
            id: id,
            type: 'users',
            attributes: {
              display_name: "User#{id}",
              shortname: "user#{id}",
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
