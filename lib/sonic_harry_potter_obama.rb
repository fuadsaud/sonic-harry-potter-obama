require 'nokogiri'
require 'terminal-table'
require 'typhoeus'

require_relative 'sonic_harry_potter_obama/products'
require_relative 'sonic_harry_potter_obama/mailing'
require_relative 'sonic_harry_potter_obama/presenting'

class SonicHarryPotterObama
  class MatchPage
    def call(product)
      product[:fn].(Nokogiri::HTML(product[:page]))
    end
  end

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

  class FetchAndMatchAll
    def call(products)
      ParallelFetchAll
        .new
        .call(products)
        .map { |product| product.merge(found: MatchPage.new.call(product)) }
    end
  end

  def call(product_map)
    products = product_map.map { |name, details| details.merge(name: name)}
    results_table = to_table(FetchAndMatchAll.new.call(products))
    term_output = PresentTerminalTable.new.call(results_table)
    email_output = PresentEmail.new.call(results_table)

    if ENV['email']
      SendMail.new.call(email_output)

      puts email_output
    end

    puts term_output
  end

  private

  def to_table(products)
    products.map { |p| [p[:found], p[:name], p[:url]] }
  end
end
