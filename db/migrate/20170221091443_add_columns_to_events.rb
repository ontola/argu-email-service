class AddColumnsToEvents < ActiveRecord::Migration[5.0]
  def change
    rename_column :events, :options, :body
  end
end
