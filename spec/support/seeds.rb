# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:suite) do
    Apartment::Tenant.create('argu') unless ApplicationRecord.connection.schema_exists?('argu')
    Apartment::Tenant.switch('argu') do
      load(Dir[Rails.root.join('db', 'seeds.rb')][0])
    end
  end

  config.after(:suite) do
    Apartment::Tenant.switch('argu') do
      Template.destroy_all
    end
  end
end
