class CreateBatches < ActiveRecord::Migration[5.0]
  def change
    create_table :batches do |t|
      t.string :template, null: false
      t.json :options, null: false
      t.datetime :processed_at
      t.string :job_id
      t.string :caller_id
      t.timestamps
    end
  end
end
