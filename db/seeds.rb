# frozen_string_literal: true

[
  ['confirm_secondary', false],
  ['confirm_votes', false],
  ['confirmation', false],
  ['email_token_created', false],
  ['password_changed', true],
  ['requested_confirmation', false],
  ['set_password', false],
  ['activity_notifications', true],
  ['direct_message', false]
].each { |template, show_footer| Template.create!(name: template, show_footer: show_footer) }
