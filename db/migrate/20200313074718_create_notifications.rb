class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.string :contact_number
			t.string :device_token
			t.string :device_platform

      t.boolean :is_retrieved, default: false

			t.boolean :is_activated, default: false
			t.datetime :activated_at

      t.references :container, index: true

      t.timestamps null: false
    end

    add_foreign_key :notifications, :containers
    add_index :notifications, :device_token
    
  end
end
