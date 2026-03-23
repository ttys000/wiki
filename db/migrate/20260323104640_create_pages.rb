class CreatePages < ActiveRecord::Migration[8.1]
  def change
    create_table :pages do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.text :body

      t.timestamps
    end
    add_index :pages, :title, unique: true
    add_index :pages, :slug, unique: true
  end
end
