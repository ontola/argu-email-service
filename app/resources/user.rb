# frozen_string_literal: true
class User < ServiceBase::ActiveResourceModel
  self.site = "#{Rails.configuration.oauth_url}/spi"

  def self.collection_name
    'u'
  end
end
