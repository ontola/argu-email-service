# frozen_string_literal: true
require 'service_base/active_resource_model'

class User < ServiceBase::ActiveResourceModel
  def self.collection_name
    'u'
  end
end
