class AddDraftsReminder < ActiveRecord::Migration[7.0]
  def change
    Template.create!(name: 'drafts_reminder', show_footer: false)
  end
end
