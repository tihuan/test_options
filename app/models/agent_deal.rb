class AgentDeal < ActiveRecord::Base
  belongs_to :agent
  belongs_to :deal
end
