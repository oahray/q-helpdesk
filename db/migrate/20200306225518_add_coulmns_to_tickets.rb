class AddCoulmnsToTickets < ActiveRecord::Migration[6.0]
  def change
    add_column :tickets, :processing, :boolean, default: false
    add_column :tickets, :process_start_at, :datetime
  end
end
