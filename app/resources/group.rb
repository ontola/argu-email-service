# frozen_string_literal: true

class Group < ActiveResourceModel
  self.site = '/:root_id/'
  self.collection_name = 'g'
end
