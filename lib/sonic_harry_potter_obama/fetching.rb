require 'typhoeus'

module SonicHarryPotterObama
  class ParallelFetchAll
    def call(products)
      products_with_request = products.map { |product| product.merge(request: Typhoeus::Request.new(product[:url])) }

      Typhoeus::Hydra.hydra.tap do |hydra|
        products_with_request.each do |product|
          hydra.queue(product[:request])
        end
      end.run

      products_with_request.map { |product| product.merge(page: product[:request].response.body)}
    end
  end
end
