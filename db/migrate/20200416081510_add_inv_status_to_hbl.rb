class AddInvStatusToHbl < ActiveRecord::Migration[6.0]
  def change
    add_column :hbls, :status, :string
  end
end
