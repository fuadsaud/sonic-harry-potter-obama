module SonicHarryPotterObama
  MATCHERS = {
    hering: ->(size, page) { !page.css(".product-detail-variant-size li[data-color=\"#{size}\"]".empty? ) },
    sounds: ->(size, page) { page.css('#variant [data-available="true"]').map(&:text).include?(size) },
    renner: ->(size, page) { page.css("#TAM#{size}") },
  }.map { |k, v| [k, v.curry] }.to_h
end
