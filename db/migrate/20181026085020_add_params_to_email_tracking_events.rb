class AddParamsToEmailTrackingEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :email_tracking_events, :params, :json
  end
end
