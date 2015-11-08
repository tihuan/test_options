class AddCostToAgentDeals < ActiveRecord::Migration
  def change
    add_column :agent_deals, :cost, :integer
    add_column :agent_deals, :bought_date, :date
    add_column :agent_deals, :sold_date, :date
    add_column :agent_deals, :net_gain, :integer, default: 0
  end
end
