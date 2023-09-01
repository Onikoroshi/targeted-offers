class CreateOfferCriteria < ActiveRecord::Migration[7.0]
  def change
    create_table :offer_criteria do |t|
      t.belongs_to :offer, null: false, foreign_key: true
      t.integer :min_age
      t.integer :max_age

      t.timestamps
    end
  end
end
