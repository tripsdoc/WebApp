class CreateNotificationJobs < ActiveRecord::Migration[6.0]
  def change
    create_table :notification_jobs do |t|
      t.string :title
    	t.string :message

			t.boolean :is_sent, default: false
			t.datetime :send_at

			t.references :container, index: true

      t.timestamps null: false
    end

    add_foreign_key :notification_jobs, :containers
    add_index :notification_jobs, [:container_id, :created_at]
    
  end
end
