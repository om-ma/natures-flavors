class GenerateProductFeedWorkerAwsS3
  include Sidekiq::Worker

  def perform()
    params = { 'include_images' => true }
    current_currency = Spree::Config[:currency]
    @searcher = Spree::Config.searcher_class.new(params).tap do |searcher|
      searcher.current_user = try_spree_current_user
      searcher.current_currency = current_currency
    end
    @products = @searcher.retrieve_products
    @products = @products.includes(:possible_promotions) if @products.respond_to?(:includes)

    store = Spree::Store.where(default: true).first
    ProductFeedCreatorAwsS3.call(Rails.application.default_url_options, store, current_currency, @products)
  end

  def try_spree_current_user
    # This one will be defined by apps looking to hook into Spree
    # As per authentication_helpers.rb
    if respond_to?(:spree_current_user)
      spree_current_user
    # This one will be defined by Devise
    elsif respond_to?(:current_spree_user)
      current_spree_user
    end
  end
end