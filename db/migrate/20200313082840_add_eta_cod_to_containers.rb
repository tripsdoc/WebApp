class AddEtaCodToContainers < ActiveRecord::Migration[6.0]
  def change
    add_column :containers, :eta, :datetime
  	add_column :containers, :cod, :datetime

  	add_index :containers, [:id]
  	add_index :containers, [:container_number]
  end
end
