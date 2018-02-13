require 'nokogiri'

require_relative 'products'
require_relative 'fetching'
require_relative 'presenting'
require_relative 'mailing'

module SonicHarryPotterObama
  class App
    class MatchPage
      def call(product)
        product[:fn].(Nokogiri::HTML(product[:page]))
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

    def call(products, send_email: false)
      results_table = to_table(FetchAndMatchAll.new.call(products))

      if send_email
        email_output = PresentEmail.new.call(results_table)

        SendMail.new.call(email_output)

        puts email_output
      end

      puts PresentTerminalTable.new.call(results_table)
    end

    private

    def to_table(products)
      products.map { |p| [p[:found], p[:name], p[:url]] }
    end
  end
end
