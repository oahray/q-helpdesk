class CreateTickets < ActiveRecord::Migration[6.0]
  def change
    create_table :tickets do |t|
      t.string :title
      t.text :description
      t.boolean :closed, default: false
      t.datetime :closed_at

      t.timestamps

      t.references :customer, foreign_key: { to_table: :users }, index:true
      t.references :closed_by, foreign_key: { to_table: :users }, index:true
    end
  end
end
