Spree::StructuredDataHelper.module_eval do

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
        logo: asset_url('logo.png'),
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
          logo: asset_url('logo.png')
        }
      }
    end
  end

end
