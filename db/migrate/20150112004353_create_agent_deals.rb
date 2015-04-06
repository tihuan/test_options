class CreateAgentDeals < ActiveRecord::Migration
  def change
    create_table :agent_deals do |t|
      t.belongs_to :agent, index: true
      t.belongs_to :deal, index: true

      t.timestamps null: false
    end
  end
end
