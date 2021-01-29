class CreateAppointments < ActiveRecord::Migration[6.0]
  def change
    create_table :appointments, id: :uuid do |t|
      t.uuid :attendee_id, null: false, class_name: 'User'
      t.uuid :gym_session_id, null: false

      t.timestamps
    end
  end
end
