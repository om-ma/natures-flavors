-- Can not have | in doofinder product feed
update spree_products set meta_description = replace(meta_description, '|', ',');
update spree_products set meta_title = replace(meta_title, '|', ',');