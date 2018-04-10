class CreateIncomes < ActiveRecord::Migration[5.1]
  def change
    create_table :incomes do |t|
      t.money :totalIncome
      t.bigint :transaction_id

      t.timestamps
    end
  end
end
