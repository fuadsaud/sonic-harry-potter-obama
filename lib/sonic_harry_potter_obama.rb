require 'commaparty'
require 'cape-cod'
require 'net/http'
require 'nokogiri'
require 'terminal-table'
require 'typhoeus'

require_relative 'products'
require_relative 'mailing'

class SonicHarryPotterObama
  class MatchPage
    def call(product)
      product[:fn].(Nokogiri::HTML(product[:page]))
    end
  end

  class BoolToChar
    def call(bool)
      if bool
        '✓'
      else
        '𝘹'
      end
    end
  end

  class PresentTerminalTable
    def call(results)
      Terminal::Table.new(rows: results.map { |result| present(result) }, style: { border_x: '–' }).to_s
    end

    private

    def present(result)
      [BoolToChar.new.call(result.first), *result[1..-1]].map { |r| colorize(result.first, r) }
    end

    def colorize(found, s)
      if found
        colorize_found(s)
      else
        s
      end
    end

    def colorize_found(s)
      CapeCod.fg(0, 255, 0, s)
    end
  end

  class PresentEmail
    def call(results)
      CommaParty.markup(
        [:table,
         results.map { |result|
          [:tr,
           present(result).map { |r|
            [:td, r]
          }]
        }])
    end

    private

    def present(result)
      [BoolToChar.new.call(result.first), *result[1..-1]]
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
