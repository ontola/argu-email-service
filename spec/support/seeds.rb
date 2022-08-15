# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:suite) do
    load(Dir[Rails.root.join('db/seeds.rb')][0])
  end

  config.after(:suite) do
    Template.destroy_all
  end
end
