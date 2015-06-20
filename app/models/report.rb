class Report < ActiveRecord::Base
  belongs_to :agent
  has_many :reports_deals
  has_many :deals, through: :reports_deals
end
