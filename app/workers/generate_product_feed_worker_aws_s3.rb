class GenerateProductFeedWorkerAwsS3
  include Sidekiq::Worker

  def perform()
    feeds = [
      ['b','c'],
      ['a','d','e','f','g','h','i','j','k','l','m','n'],
      ['o'],
      ['p','q','r','s','t','u','v','w','x','y','z']
    ]
    params = { 'include_images' => true }
    current_currency = Spree::Config[:currency]
    @searcher = Spree::Config.searcher_class.new(params).tap do |searcher|
      searcher.current_user = try_spree_current_user
      searcher.current_currency = current_currency
    end
    @products = @searcher.retrieve_products
    @products = @products.includes(:possible_promotions).order(:name) if @products.respond_to?(:includes)
    store = Spree::Store.where(default: true).first

    feeds.each_with_index do |f, index|
      conditions = get_like_conditions(f)
      products_subset = @products.where(conditions)
      ProductFeedCreatorAwsS3.call(Rails.application.default_url_options, store, current_currency, products_subset, index)
    end
  end

  def get_like_conditions(f)
    conditions = f.map do |letter|
      "name ilike '#{letter}%'"
    end
    conditions.join(' OR ')
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