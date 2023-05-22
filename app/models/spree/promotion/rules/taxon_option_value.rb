module Spree
  class Promotion
    module Rules
      module TaxonOptionValueWithNumerificationSupport
        def preferred_eligible_values
          values = super || {}
          Hash[values.keys.map(&:to_i).zip(
            values.values.map do |v|
              (v.is_a?(Array) ? v : v.split(',')).map(&:to_i)
            end
          )]
        end
      end

      class TaxonOptionValue < PromotionRule
        prepend TaxonOptionValueWithNumerificationSupport

        has_many :promotion_rule_taxons_option_value, class_name: 'Spree::PromotionRuleTaxonOptionValue',
                                         foreign_key: 'promotion_rule_id',
                                         dependent: :destroy
        has_many :taxons, through: :promotion_rule_taxons_option_value, class_name: 'Spree::Taxon'

        MATCH_POLICIES = %w(any all)
        preference :match_policy, :string, default: MATCH_POLICIES.first
        preference :eligible_values, :hash

        def applicable?(promotable)
          promotable.is_a?(Spree::Order)
        end

        def eligible?(promotable, _options = {})
          case preferred_match_policy
          when 'any'
            promotable.line_items.any? { |item| actionable?(item) }
          end
        end

        def actionable?(line_item)
          store = line_item.order.store

          store.products.
            joins(:classifications).
            where(Spree::Classification.table_name => { taxon_id: taxon_ids, product_id: line_item.product_id }).
            exists? &&
          option_value_actionable?(line_item)
        end

        def option_value_actionable?(line_item)
          option_type_ids = line_item.product.option_type_ids
          option_values_ids = line_item.variant.option_value_ids
          eligible_option_type_ids = preferred_eligible_values.keys
          eligible_value_ids = option_type_ids.collect{|id| preferred_eligible_values[id]}.flatten

          (eligible_option_type_ids & option_type_ids).present? && (eligible_value_ids & option_values_ids).present?
        end

        def taxon_ids_string
          taxons.pluck(:id).join(',')
        end

        def taxon_ids_string=(s)
          ids = s.to_s.split(',').map(&:strip)
          self.taxons = Spree::Taxon.for_stores(stores).find(ids)
        end
      end
    end
  end
end
