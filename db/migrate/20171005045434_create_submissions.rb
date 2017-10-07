class CreateSubmissions < ActiveRecord::Migration[5.1]
  def change
    create_table :submissions do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.text :meta_data_json

      t.integer :campaign_id
      t.integer :customer_id
      t.timestamps null: false
    end
  end
end
