class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.text :body
      t.boolean :edited, default: false

      t.timestamps

      t.references :ticket, foreign_key: true, index:true
      t.references :user, foreign_key: true, index:true
    end
  end
end
