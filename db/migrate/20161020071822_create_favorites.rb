class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.references :favo, index: true
      t.references :favoed, index: true

      t.timestamps null: false
      
      t.index [:favo_id, :favoed_id], unique: true
    end
  end
end
