class AddReportProperties < ActiveRecord::Migration
  def change
    change_table :reports do |t|
      t.belongs_to :agent, index: true
      t.string :headers, default: %w()
    end
  end
end
