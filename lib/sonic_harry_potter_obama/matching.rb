module SonicHarryPotterObama
  MATCHERS = {
    hering: ->(size, page) { !page.css(".product-detail-variant-size li[data-color=\"#{size}\"]".empty? ) },
    renner: ->(size, page) { !page.css(".skuSizeList .inptRadio[name=\"#{size}\"]").empty? },
    sounds: ->(size, page) { page.css('#variant [data-available="true"]').map(&:text).include?(size) },
    renner_new: ->(size, page) { page.css("#TAM#{size}") },
  }.map { |k, v| [k, v.curry] }.to_h
end
