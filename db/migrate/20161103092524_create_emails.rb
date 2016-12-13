class CreateEmails < ActiveRecord::Migration[5.0]
  def change
    create_table :emails do |t|
      t.json :options
      t.json :recipient, null: false
      t.string :template, null: false
      t.integer :event_id, null: false
      t.string :sent_to
      t.datetime :sent_at
      t.string :mailgun_id
      t.timestamps
    end
  end
end
