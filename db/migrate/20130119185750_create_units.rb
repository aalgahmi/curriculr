class CreateUnits < ActiveRecord::Migration[5.0]
  def change
    create_table :units do |t|
      t.belongs_to :course, index: true
      t.integer :order, :default => 0
      t.string :name
      t.text :about
      t.integer :lectures_count, :default => 0
      t.integer :assessments_count, :default => 0
      t.integer :pages_count, :default => 0
      t.date :on_date
      t.date :based_on
      t.integer :for_days
      t.boolean :previewed, :default => false

      t.timestamps null: false
    end

    add_foreign_key :units, :courses
  end
end
