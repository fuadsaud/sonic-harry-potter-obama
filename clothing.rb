#!/usr/bin/env ruby

require 'commaparty'
require 'cape-cod'
require 'net/http'
require 'nokogiri'
require 'sendgrid-ruby'
require 'terminal-table'

require_relative 'products'

class Clothing
  class FetchPage
    def call(product)
      Net::HTTP.get(URI(product[:url]))
    end
  end

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

  class SendMail
    include SendGrid

    def call(content)
      from = Email.new(email: 'fuadfsaud@gmail.com')
      subject = 'Clothing Report'
      to = Email.new(email: 'fuadfsaud@gmail.com')
      content = Content.new(type: 'text/html', value: content)
      mail = Mail.new(from, subject, to, content)

      sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
      response = sg.client.mail._('send').post(request_body: mail.to_json)
    end
  end

  class FetchAll
    def call(products)
      products
        .map { |name, details| details.merge(name: name) }
        .map { |product| product.merge(page: FetchPage.new.call(product)) }
        .map { |product| product.merge(found: MatchPage.new.call(product)) }
    end
  end

  def call
    results_table = to_table(FetchAll.new.call(PRODUCTS))
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

Clothing.new.call
