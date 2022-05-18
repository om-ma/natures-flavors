Deface::Override.new(
  virtual_path: 'spree/layouts/spree_application',
  name: 'add_doofinder_to_spree_application',
  insert_bottom: "[data-hook='body']",
  partial: 'spree/shared/doofinder'
)
