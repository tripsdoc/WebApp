class CreateContainers < ActiveRecord::Migration[6.0]
  def change
    create_table :containers do |t|
      t.string :container_uid # Container Unique ID, need to get from client
      t.string :container_prefix
    	t.string :container_number
    	t.date :schedule_date
    	t.date :unstuff_date
    	t.datetime :last_day

      t.date :f5_unstuff_date
      t.datetime :f5_last_day

      t.string :location

  		t.timestamps null: false
    end
  end
end
