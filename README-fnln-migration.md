-- Update using ship address
update spree_users a
set first_name = b.firstname, last_name = b.lastname
from spree_addresses b
where
a.first_name = '' and
a.ship_address_id = b.id and
a.ship_address_id is not null
;

-- Update using bill address
update spree_users a
set first_name = c.firstname, last_name = c.lastname
from spree_addresses c
where
a.first_name = '' and
a.bill_address_id = c.id and
a.bill_address_id is not null
;