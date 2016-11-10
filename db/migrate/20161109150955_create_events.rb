class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.integer :email_id
      t.string :event
      t.timestamps
    end
  end
end
