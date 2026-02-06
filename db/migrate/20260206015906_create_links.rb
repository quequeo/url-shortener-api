class CreateLinks < ActiveRecord::Migration[8.1]
  def change
    create_table :links do |t|
      t.references :user, null: false, foreign_key: { on_delete: :cascade }, index: true
      t.string :original_url, null: false
      t.string :short_code, null: false
      t.integer :click_count, null: false, default: 0

      t.timestamps
    end

    add_index :links, :short_code, unique: true
  end
end
