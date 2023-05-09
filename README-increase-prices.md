# DB migration: add spree_prices.amount_old
rails generate migration add_amount_old_to_spree_prices amount_old:decimal
  (add_column :spree_prices, :amount_old,  :decimal, precision: 10, scale: 2, default: 0.0, null: false)

bundle exec rake db:migrate

# Save current amount to amount_old
update spree_prices set amount_old = amount;

# All variants with new_amount
select b.id as product_id, a.id as variant_id, c.id as price_id, b.name, a.sku, a.is_master, c.amount, c.amount_old, (c.amount_old * 1.05) as new_amount_raw, ROUND((c.amount_old * 1.05)/5,2) * 5 as new_amount
from spree_variants a
join spree_products b on b.id = a.product_id
join spree_prices c on c.variant_id = a.id
where b.discontinue_on is null and c.deleted_at is null
order by b.name, a.sku;
