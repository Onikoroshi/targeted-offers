class AddActivenessToOfferCriteria < ActiveRecord::Migration[7.0]
  def change
    add_column :offer_criteria, :active_from, :date
    add_column :offer_criteria, :active_to, :date
  end
end
