#!/usr/bin/env ruby

require 'net/http'
require 'terminal-table'
require 'cape-cod'
require 'sendgrid-ruby'

module Clothing
  MATCHERS = {
    hering: ->(size, page) { page =~ /data-color="#{size}"/ }.curry,
    sounds_size: ->(size, page) { page =~ /data-available="true"\sdata-original_price="R\$\s60,00"\svalue="\d+">#{size}</ }.curry,
    sounds_size_style: ->(size, style, page) { page =~ /data-available="true"\sdata-original_price="R\$\s60,00"\svalue="\d+">#{size} #{style}</ }.curry
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
    }
  }

  class << self
    def get(url)
      Net::HTTP.get(URI(url))
    end

    def fetch(name, details)
      url = details[:url]
      fn = details[:fn]
      found = fn.(get(details[:url]))

      [found, name, url]
    end

    def colorize_found(s)
      CapeCod.fg(0, 255, 0, s)
    end

    def present(result)
      if result.first
        ['✓', *result[1..-1]].map { |s| colorize_found(s) }
      else
        ['𝘹', *result[1..-1]]
      end
    end

    def fetch_and_present_all
      PRODUCTS
        .map { |name, details| self.fetch(name, details) }
        .map { |r| present(r) }
    end
  end
end

class Mailer
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

rendered_results = Terminal::Table.new(rows: Clothing.fetch_and_present_all, style: { border_x: '–' }).to_s

if ENV['email']
  Mailer.new.call(rendered_results)
end

puts rendered_results
