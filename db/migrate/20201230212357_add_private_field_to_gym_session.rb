class AddPrivateFieldToGymSession < ActiveRecord::Migration[6.0]
  def change
    add_column :gym_sessions, :is_private, :boolean
    add_column :gym_sessions, :instructor_id, :uuid
    add_index :gym_sessions, :instructor_id
  end
end
