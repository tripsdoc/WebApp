class AddHblToNotification < ActiveRecord::Migration[6.0]
  def change
    add_reference :notifications, :hbl, foreign_key: true
  end
end
