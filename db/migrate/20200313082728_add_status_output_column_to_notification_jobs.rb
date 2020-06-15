class AddStatusOutputColumnToNotificationJobs < ActiveRecord::Migration[6.0]
  def change
    add_column :notification_jobs, :status_output, :string
  end
end
