# frozen_string_literal: true
module RequestHelpers
  def parsed_body
    @json ||= JSON.parse(response.body)
  end
end
