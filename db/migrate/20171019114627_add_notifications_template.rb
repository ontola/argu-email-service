class AddNotificationsTemplate < ActiveRecord::Migration[5.0]
  def change
    Template.create!(name: 'activity_notifications', show_footer: true)
  end
end
