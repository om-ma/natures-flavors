# app/workers/update_product_sold_counts_worker.rb
class UpdateProductSoldCountsWorker
  include Sidekiq::Worker

  def perform(order_id)
    order = Spree::Order.find(id: order_id)

    begin
      order.line_items.each do |line_item|
        product = line_item.variant.product
        product.update(total_units_sold: product.total_units_sold + line_item.quantity)
      end

      Rails.logger.info "Updated total_units_sold for products based on order: #{order.number}"
    rescue StandardError => e
      Rails.logger.error "Error updating total_units_sold for products based on order: #{order.number}"
      Rails.logger.error e.message
      Rails.logger.error e.backtrace.join("\n")
    end
  end
end
