class CreateGymSessions < ActiveRecord::Migration[6.0]
  def change
    create_table :gym_sessions do |t|
      t.string :title, null: false
      t.text :description, null:false
      t.datetime :start_time, null: false
      t.integer :duration, null: false

      t.timestamps
    end
  end
end
