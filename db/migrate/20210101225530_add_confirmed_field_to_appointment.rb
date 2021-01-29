class AddConfirmedFieldToAppointment < ActiveRecord::Migration[6.0]
  def change
    add_column :appointments, :confirmed, :boolean, default: false
  end
end
