class CreateVisits < ActiveRecord::Migration[8.1]
  def change
    create_table :visits do |t|
      t.references :link, null: false, foreign_key: { on_delete: :cascade }, index: true
      t.string :ip_address
      t.string :user_agent

      t.timestamps
    end
  end
end
