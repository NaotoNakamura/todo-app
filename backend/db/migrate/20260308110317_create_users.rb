class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :provider_name
      t.string :provider_uid
      t.string :email

      t.timestamps
    end
  end
end
