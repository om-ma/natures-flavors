Spree::StructuredDataHelper.module_eval do

  def structured_product_hash(product)
    Rails.cache.fetch(common_product_cache_keys + ["spree/structured-data/#{product.cache_key_with_version}"]) do
      {
        '@context': 'https://schema.org/',
        '@type': 'Product',
        aggregateRating: structured_aggregate_rating(product),
        url: spree.product_url(product),
        name: product.name,
        image: structured_images(product),
        description: product.description,
        sku: structured_sku(product),
        offers: {
          '@type': 'Offer',
          price: product.default_variant.price_in(current_currency).amount,
          priceCurrency: current_currency,
          availability: product.in_stock? ? 'InStock' : 'OutOfStock',
          url: spree.product_url(product),
          availabilityEnds: product.discontinue_on ? product.discontinue_on.strftime('%F') : ''
        },
        review: structured_reviews(product)
      }.compact_blank
    end
  end

  def structured_aggregate_rating(product)
    rich_snippets = product.yotpo_rich_snippets()

    if rich_snippets.present? && rich_snippets['response']['bottomline']['average_score'].to_i > 0
      {
        '@type': 'AggregateRating',
        ratingValue: rich_snippets['response']['bottomline']['average_score'],
        reviewCount: rich_snippets['response']['bottomline']['total_reviews'],
        bestRating: 5,
        worstRating: 1
      }
    else
      nil
    end
  end

  def structured_reviews(product)
    reviews = product.yotpo_reviews()
    
    if reviews.present?
      reviews['response']['reviews'].map do |review|
        {
          '@type': 'Review',
          reviewRating: {
            '@type': 'Rating',
            ratingValue: review['score']
          },
          author: {
            '@type': 'Person',
            name: review['user']['display_name']
          },
          datePublished: review['created_at'],
          reviewBody: review['content']
        }
      end
    else
      nil
    end
  end

  def organization_structured_data(store)
    content_tag :script, type: 'application/ld+json' do
      raw(
        structured_organization_hash(store).to_json
      )
    end
  end

  def faqs_structured_data(faqs)
    content_tag :script, type: 'application/ld+json' do
      raw(
        structured_faqs_hash(faqs).to_json
      )
    end
  end

  def article_structured_data(title, description)
    content_tag :script, type: 'application/ld+json' do
      raw(
        structured_article_hash(title, description).to_json
      )
    end
  end

  private

  def structured_organization_hash(store)
    Rails.cache.fetch([store.name, "spree/structured-data/#{store.cache_key_with_version}"]) do
      {
        '@context': 'https://schema.org/',
        '@type': 'Organization',
        '@id': 'https://' + store.url,
        name: store.name,
        url: 'https://' + store.url,
        logo: asset_url('theme_logo.svg'),
        address: {
          '@type': 'PostalAddress',
          addressCountry: 'United States',
          addressLocality: 'Orange',
          addressRegion: 'CA',
          postalCode: '92867',
          name: 'Nature''s Flavors',
          streetAddress: '833 N. Elm Street'
        },
        email: 'mailto:customerservice@naturesflavors.com',
        telephone: '(714) 744-3700',
        sameAs: [
          'https://www.facebook.com/NaturesFlavors',
          'https://twitter.com/natures_flavors',
          'https://www.youtube.com/user/NaturesFlavors',
          'https://www.pinterest.com/naturesflavors',
          'https://www.instagram.com/natures_flavors'
        ]
      }
    end
  end

  def structured_faqs_hash(faqs)
    Rails.cache.fetch(['faqs', "spree/structured-data/#{faqs}"]) do
      {
        '@context': 'https://schema.org/',
        '@type': 'FAQPage',
        mainEntity: 
          faqs.map do |faq|
            structured_faq(faq)
          end
      }
    end
  end

  def structured_faq(faq)
    {
      "@type": "Question",
      name: faq[0],
      acceptedAnswer: {
        '@type': "Answer",
        text: faq[1]
      }
    }
  end

  def structured_article_hash(title, description)
    Rails.cache.fetch(['article', title, "spree/structured-data/#{description}"]) do
      {
        '@context': 'https://schema.org/',
        '@type': 'Article',
        headline: title,
        abstract: description,
        publisher: {
          '@type': 'Organization',
          name: "Nature's Flavors",
          logo: asset_url('theme_logo.svg')
        }
      }
    end
  end

end
