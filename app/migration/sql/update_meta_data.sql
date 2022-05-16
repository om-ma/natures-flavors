-- SQL to update meta data without "|" for doofinder
update spree_products set meta_description = replace(meta_description, '|', ',');
update spree_products set meta_keywords = replace(meta_keywords, '|', ',');