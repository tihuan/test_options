class CreateAgents < ActiveRecord::Migration
  def change
    create_table :agents do |t|
      t.integer :balance, default: 20000

      t.timestamps null: false
    end
  end
end
