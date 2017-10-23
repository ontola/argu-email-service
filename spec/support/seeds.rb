# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:suite) do
    [
      ['confirm_secondary', false],
      ['confirm_votes', false],
      ['confirmation', false],
      ['email_token_created', false],
      ['password_changed', true],
      ['requested_confirmation', false],
      ['set_password', false],
      ['activity_notifications', false]
    ].each { |template, show_footer| Template.create!(name: template, show_footer: show_footer) }
  end

  config.after(:suite) do
    Template.destroy_all
  end
end
