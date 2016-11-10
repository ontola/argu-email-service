# frozen_string_literal: true
class ActiveResourceModel < ActiveResource::Base
  self.site = Rails.configuration.oauth_url

  def self.instantiate_record(record, prefix_options = {})
    super(record['attributes'].merge('id' => record['id']), prefix_options)
  end
end
