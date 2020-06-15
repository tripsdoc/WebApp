class AddTotalAmountToHbl < ActiveRecord::Migration[6.0]
  def change
    add_column :hbls, :total_amount, :string
  end
end
