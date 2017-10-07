class CreateCampaignTable < ActiveRecord::Migration[5.1]
  def change
    create_table :campaigns do |t|
      t.string :campaign_name
      t.datetime :start_date
      t.datetime :end_date
      t.integer :max_entries
      t.integer :max_winners
      t.boolean :agree_to_terms, default: false
      t.boolean :limit_per_ip, default: false
      t.boolean :limit_per_email, default: false
      t.text :campaign_products
      t.text :campaign_collections
      t.timestamps null: false
    end
  end
end
