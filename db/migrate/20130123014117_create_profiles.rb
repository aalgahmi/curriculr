class CreateProfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :profiles do |t|
    	t.belongs_to :user, :null => false, index: true
      t.string :nickname
      t.string :prefix
      t.string :avatar
      t.string :locale
			t.text :about
      t.boolean :public, :default => false

      t.timestamps null: false
    end

    add_foreign_key :profiles, :users
  end
end
