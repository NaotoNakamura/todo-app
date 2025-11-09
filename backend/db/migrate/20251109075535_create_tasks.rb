class CreateTasks < ActiveRecord::Migration[8.1]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.datetime :started_at
      t.datetime :finished_at
      t.boolean :is_completed, null: false, default: false

      t.timestamps
    end
  end
end
