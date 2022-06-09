-- Delete all taxon associations from old_product_id = 57612 (NF-8416/ORG). Used to create all taxons.
select product_id from spree_products where old_product_id = 57612;
delete from spree_products_taxons where product_id = <product_id>;