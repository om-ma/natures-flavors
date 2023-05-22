class CreateSpreePromotionRuleTaxonOptionValues < ActiveRecord::Migration[6.1]
  def change
    create_table :spree_promotion_rule_taxon_option_values do |t|
      t.references :taxon, index: true
      t.references :promotion_rule, index: {:name => "idx_spree_promotion_rule_taxon_option_values_promotion_rule_id"}
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
