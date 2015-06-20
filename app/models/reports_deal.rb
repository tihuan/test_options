class ReportsDeal < ActiveRecord::Base
  belongs_to :report
  belongs_to :deal
end
