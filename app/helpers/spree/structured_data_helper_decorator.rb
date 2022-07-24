Spree::StructuredDataHelper.module_eval do

  def organization_structured_data(store)
    content_tag :script, type: 'application/ld+json' do
      raw(
        structured_organization_hash(store)
      )
    end
  end

  private

  def structured_organization_hash(store)
    Rails.cache.fetch(["spree/structured-data/#{store.cache_key_with_version}"]) do
      {
        '@context': 'https://schema.org/',
        '@type': 'Organization',
        '@id': 'https://' + store.url,
        name: store.name,
        url: 'https://' + store.url,
        logo: asset_path('logo.png'),
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

end
