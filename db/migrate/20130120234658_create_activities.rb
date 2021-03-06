class CreateActivities < ActiveRecord::Migration[5.0]
  def change
    create_table :activities do |t|
      t.belongs_to :klass, index: true
      t.belongs_to :student, index: true
      t.references :context, :polymorphic => true
      t.references :actionable, :polymorphic => true
      t.string :action
      t.integer :times, :default => 0
      t.float :points, :default => 0.0
      t.text :data

      t.timestamps null: false
    end

    add_foreign_key :activities, :klasses
    add_foreign_key :activities, :students
  end
end
