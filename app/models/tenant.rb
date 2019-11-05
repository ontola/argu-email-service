# frozen_string_literal: true

class Tenant
  def self.create(schema)
    Apartment::Tenant.create(schema) unless ApplicationRecord.connection.schema_exists?(name)
    Apartment::Tenant.switch(schema) do
      load(Dir[Rails.root.join('db', 'seeds.rb')][0])
    end
  end
end
