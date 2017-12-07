class AddDirectMessageTemplate < ActiveRecord::Migration[5.0]
  def up
    Template.create!(name: 'direct_message', show_footer: false)
  end

  def down
    Template.find_by(name: 'direct_message').destroy
  end
end
