class AddHblToNotificationItems < ActiveRecord::Migration[6.0]
  def change
    add_column :notification_items, :hbl_uid, :string
  end
end
