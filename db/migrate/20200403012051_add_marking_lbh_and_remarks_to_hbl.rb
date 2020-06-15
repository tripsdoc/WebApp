class AddMarkingLbhAndRemarksToHbl < ActiveRecord::Migration[6.0]
  def change
    add_column :hbls, :markings, :string
    add_column :hbls, :length, :string
    add_column :hbls, :breadth, :string
    add_column :hbls, :height, :string
    add_column :hbls, :remarks, :string
  end
end
