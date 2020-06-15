class AddIsNewToNotificationItems < ActiveRecord::Migration[6.0]
  def change
    add_column :notification_items, :is_new, :boolean, default: false
  	add_column :notification_items, :title, :string
  	add_column :notification_items, :colour, :string
  end
end
