class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :event, null: false
      t.string :resource_id, null: false
      t.string :resource_type, null: false
      t.string :type, null: false
      t.json :options, null: false
      t.string :job_id
      t.datetime :processed_at
      t.timestamps
    end
  end
end
