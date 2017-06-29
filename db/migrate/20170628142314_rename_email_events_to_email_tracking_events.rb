class RenameEmailEventsToEmailTrackingEvents < ActiveRecord::Migration[5.0]
  def change
    rename_table :email_events, :email_tracking_events
  end
end
