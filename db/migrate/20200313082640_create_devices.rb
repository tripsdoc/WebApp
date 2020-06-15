class CreateDevices < ActiveRecord::Migration[6.0]
  def change
    create_table :devices do |t|
      t.string :device_token, :unique => true
			t.string :device_platform

      t.timestamps null: false
    end

    add_index :devices, :device_token, :unique => true
    
  end
end
