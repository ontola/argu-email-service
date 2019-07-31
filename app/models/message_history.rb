# frozen_string_literal: true

class MessageHistory < Mailjet::Messagehistory
  class << self
    def index(id, options = {})
      opts = define_options(options)
      attribute_array = parse_api_json(connection(opts)[id].get(default_headers))
      attribute_array.map { |attributes| instanciate_from_api(attributes) }
    rescue Mailjet::ApiError => e
      raise e unless e.code == 404
    end
  end
end
