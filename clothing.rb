#!/usr/bin/env ruby

require 'cape-cod'
require 'csv'
require 'net/http'
require 'sendgrid-ruby'
require 'terminal-table'

class Clothing
  MATCHERS = {
    hering: ->(size, page) { page =~ /data-color="#{size}"/ }.curry,
    sounds_size: ->(size, page) { page =~ /data-available="true"\sdata-original_price="R\$\s60,00"\svalue="\d+">#{size}</ }.curry,
    sounds_size_style: ->(size, style, page) { page =~ /data-available="true"\sdata-original_price="R\$\s60,00"\svalue="\d+">#{size} #{style}</ }.curry,
    renner_size: ->(size, page) { page =~ /inptRadio" name="#{size}"/ }.curry
  }

  PRODUCTS = {
    'Hering Jogger Branca' => {
      url: 'https://www.hering.com.br/store/pt/p/calca-masculina-basica-jogger-em-moletom-peluciado-hering-05M3M2H07S4',
      fn: MATCHERS[:hering].('M')
    },
    'Hering Jogger Preta' => {
      url: 'https://www.hering.com.br/store/pt/p/calca-masculina-basica-jogger-em-moletom-peluciado-hering-05M3N1007S5',
      fn: MATCHERS[:hering].('M')
    },
    'Grande Acordo Nacional' => {
      url: 'https://www.soundandvision.com.br/produtos/grande-acordo-nacional',
      fn: MATCHERS[:sounds_size_style].('M').('preto')
    },
    'Tudo Muito Dark' => {
      url: 'https://www.soundandvision.com.br/produtos/udo-mui-o-dark-udo-mui-o-dark',
      fn: MATCHERS[:sounds_size_style].('M').('preta')
    },
    'Coma Churros' => {
      url: 'https://www.soundandvision.com.br/produtos/coma-churros',
      fn: MATCHERS[:sounds_size].('M')
    },
    'Batiminha LP' => {
      url: 'https://www.soundandvision.com.br/produtos/batiminha-lp',
      fn: MATCHERS[:sounds_size].('M')
    },
    'Batiminha' => {
      url: 'https://www.soundandvision.com.br/produtos/batiminha',
      fn: MATCHERS[:sounds_size].('M')
    },
    'Deus Nunca Perdoe' => {
      url: 'https://www.soundandvision.com.br/produtos/que-deus-nunca-perdoe-essas-pessoas-e75a11ee-dc89-4f67-a05e-6dc7976cd97c',
      fn: MATCHERS[:sounds_size].('M')
    },
    'Obama' => {
      url: 'https://www.soundandvision.com.br/produtos/obama-caa73265-f39e-42bb-8c29-d67af76a14d7',
      fn: MATCHERS[:sounds_size].('M')
    },
    'JAQUETA BOMBER REVERSÍVEL' => {
      url: 'http://www.lojasrenner.com.br/p/jaqueta-bomber-reversivel-542675088-542675125',
      fn: MATCHERS[:renner_size].('M')
    },
    'JAQUETA ALONGADA REVERSÍVEL' => {
      url: 'http://www.lojasrenner.com.br/p/jaqueta-alongada-reversivel-544154850-544154876',
      fn: MATCHERS[:renner_size].('M')
    },
    'JAQUETA PARKA COM CAPUZ BRANCA' => {
      url: 'http://www.lojasrenner.com.br/p/jaqueta-parka-com-capuz-543157477-543157514',
      fn: MATCHERS[:renner_size].('M')
    },
    'JAQUETA PARKA COM CAPUZ AZUL' => {
      url: 'http://www.lojasrenner.com.br/p/jaqueta-parka-com-capuz-543157477-543244600',
      fn: MATCHERS[:renner_size].('M')
    }
  }

  class FetchPage
    def call(product)
      Net::HTTP.get(URI(product[:url]))
    end
  end

  class MatchPage
    def call(product)
      product[:fn].(product[:page])
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
    def call(data)
      CSV.generate(col_sep: ' | ') do |csv|
        data.each do |d|
          csv << present(d)
        end
      end
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
      content = Content.new(type: 'text/plain', value: content)
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
    csv_output = PresentEmail.new.call(results_table)

    if ENV['email']
      SendMail.new.call(csv_output)
    end

    puts term_output
    puts csv_output
  end

  private

  def to_table(products)
    products.map { |p| [p[:found], p[:name], p[:url]] }
  end
end

Clothing.new.call
