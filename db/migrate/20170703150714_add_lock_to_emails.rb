class AddLockToEmails < ActiveRecord::Migration[5.0]
  def change
    add_column :emails, :lock_version, :integer, default: 0
  end
end
