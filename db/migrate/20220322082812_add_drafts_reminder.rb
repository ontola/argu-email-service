class AddDraftsReminder < ActiveRecord::Migration[5.2]
  def change
    Template.create!(name: 'drafts_reminder', show_footer: false)
  end
end
