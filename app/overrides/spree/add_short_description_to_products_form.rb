Deface::Override.new(
  virtual_path: 'spree/admin/products/_form',
  name: 'add_short_description_to_products_form',
  insert_before: "[data-hook='admin_product_form_description']",
  partial: "spree/admin/products/short_description"
)
