class AddCostToAgentDeals < ActiveRecord::Migration
  def change
    add_column :agent_deals, :cost, :integer
  end
end
