class CreateTrophies < ActiveRecord::Migration[6.1]
  def change
    create_table :trophies do |t|
      t.string :name
      t.belongs_to :question, foreign_key: true, null: false

      t.timestamps
    end
  end
end
