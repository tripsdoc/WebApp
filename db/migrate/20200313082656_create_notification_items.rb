class CreateNotificationItems < ActiveRecord::Migration[6.0]
  def change
    create_table :notification_items do |t|
      t.string :container_number
    	t.string :message

    	t.references :device, index: true

      t.timestamps null: false
    end

    add_foreign_key :notification_items, :devices
    
  end
end
