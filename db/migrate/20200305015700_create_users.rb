class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email, index: true
      t.string :password_digest
      t.boolean :admin, default: false
      t.boolean :support_agent, default: false

      t.timestamps
    end
  end
end
