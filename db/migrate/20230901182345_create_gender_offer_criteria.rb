class CreateGenderOfferCriteria < ActiveRecord::Migration[7.0]
  def change
    create_table :gender_offer_criteria do |t|
      t.belongs_to :offer_criterion, null: false, foreign_key: true
      t.belongs_to :gender, null: false, foreign_key: true

      t.timestamps
    end
  end
end
