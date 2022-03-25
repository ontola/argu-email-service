class AddMailStatus < ActiveRecord::Migration[5.2]
  def change
    add_column :emails, :source_identifier, :uuid
  end
end
