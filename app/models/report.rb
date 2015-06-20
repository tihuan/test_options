class Report < ActiveRecord::Base
  has_many :reports_deals
  has_many :deals, through: :reports_deals
end
