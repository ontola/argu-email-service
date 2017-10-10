class AllowEventIdNull < ActiveRecord::Migration[5.0]
  def change
    change_column_null :emails, :event_id, true
  end
end
