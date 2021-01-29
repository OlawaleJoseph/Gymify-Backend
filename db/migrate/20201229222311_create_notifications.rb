class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications, id: :uuid do |t|
      t.uuid :receiver_id, null: false, class_name: 'User'
      t.text :message, null: false
      t.boolean :is_read, default: false
      t.timestamps
    end
  end
end
