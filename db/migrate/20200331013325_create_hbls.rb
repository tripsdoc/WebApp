class CreateHbls < ActiveRecord::Migration[6.0]
  def change
    create_table :hbls do |t|
      t.string :inventory_id
      t.string :hbl_uid

      t.string :sequence_no
      t.string :sequence_prefix

      t.string :pod

      t.string :mquantity
      t.string :mtype
      t.string :mvolume
      t.string :mweight

      t.references :container, index: true

      t.timestamps null: false
    end

    add_foreign_key :hbls, :containers

  end
end
