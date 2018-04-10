class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.money :transferred
      t.money :comission
      t.money :rate
      t.money :total
      t.bigint :created_by
      t.bigint :destination

      t.timestamps
    end
  end
end
