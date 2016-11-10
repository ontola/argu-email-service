class CreateEmail < ActiveRecord::Migration[5.0]
  def change
    create_table :emails do |t|
      t.json :options
      t.json :recipient, null: false
      t.integer :batch_id, null: false
      t.string :sent_to
      t.datetime :sent_at
      t.string :mailgun_id
      t.timestamps
    end
  end
end
