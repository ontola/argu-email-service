# frozen_string_literal: true

class User < ActiveResourceModel
  def self.collection_name
    'u'
  end

  def language
    attributes['language'] || I18n.default_locale
  end
end
