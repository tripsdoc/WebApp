class AddHblToNotificationJob < ActiveRecord::Migration[6.0]
  def change
    add_reference :notification_jobs, :hbl, foreign_key: true
  end
end
