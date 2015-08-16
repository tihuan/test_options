class Deal < ActiveRecord::Base
  belongs_to :trade_date
  has_many :agent_deals
  has_many :agents, through: :agent_deals
end
