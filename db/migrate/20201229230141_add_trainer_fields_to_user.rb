class AddTrainerFieldsToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :speciality, :string, null: true
    add_column :users, :info, :text, null: true
    add_column :users, :is_trainer, :boolean, default: false
  end
end
