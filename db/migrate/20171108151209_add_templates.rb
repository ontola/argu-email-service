class AddTemplates < ActiveRecord::Migration[5.0]
  def change
    Template.create!(name: 'reset_password_instructions', show_footer: false)
  end
end
