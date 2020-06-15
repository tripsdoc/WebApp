class AddClientToContainer < ActiveRecord::Migration[6.0]
  def change
    add_column :containers, :client_id, :string
  end
end
