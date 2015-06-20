class CreateReportsDeals < ActiveRecord::Migration
  def change
    create_table :reports_deals do |t|

      t.timestamps null: false
    end
  end
end
