class AddDefaultsToCampaignTable < ActiveRecord::Migration[5.1]
  def change
    change_column :campaigns, :max_winners, :integer, default: 1
    change_column :campaigns, :max_entries, :integer, default: 10
  end
end
