require_relative 'matching'

class SonicHarryPotterObama
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
      fn: MATCHERS[:sounds].('M preto')
    },
    'Tudo Muito Dark' => {
      url: 'https://www.soundandvision.com.br/produtos/udo-mui-o-dark-udo-mui-o-dark',
      fn: MATCHERS[:sounds].('M preta')
    },
    'Coma Churros' => {
      url: 'https://www.soundandvision.com.br/produtos/coma-churros',
      fn: MATCHERS[:sounds].('M')
    },
    'Batiminha LP' => {
      url: 'https://www.soundandvision.com.br/produtos/batiminha-lp',
      fn: MATCHERS[:sounds].('M')
    },
    'Batiminha' => {
      url: 'https://www.soundandvision.com.br/produtos/batiminha',
      fn: MATCHERS[:sounds].('M')
    },
    'The Dark Side of Batiminha' => {
      url: 'https://www.soundandvision.com.br/produtos/the-dark-side-of-batiminha',
      fn: MATCHERS[:sounds].('M')
    },
    '1000 tretas' => {
      url: 'https://www.soundandvision.com.br/produtos/1000-tretas',
      fn: MATCHERS[:sounds].('M')
    },
    'Deus Nunca Perdoe' => {
      url: 'https://www.soundandvision.com.br/produtos/que-deus-nunca-perdoe-essas-pessoas-e75a11ee-dc89-4f67-a05e-6dc7976cd97c',
      fn: MATCHERS[:sounds].('M')
    },
    'Antifa' => {
      url: 'https://www.soundandvision.com.br/produtos/antifa',
      fn: MATCHERS[:sounds].('M')
    },
    'Obama' => {
      url: 'https://www.soundandvision.com.br/produtos/obama-caa73265-f39e-42bb-8c29-d67af76a14d7',
      fn: MATCHERS[:sounds].('M')
    },
    'Esto no es America' => {
      url: 'https://www.soundandvision.com.br/produtos/this-is-not-america',
      fn: MATCHERS[:sounds].('M')
    },
    'Ewok' => {
      url: 'https://www.soundandvision.com.br/produtos/ewok-f4e70741-e047-47f8-880b-c4200c2ada62',
      fn: MATCHERS[:sounds].('M')
    },
    'E aí blz?' => {
      url: 'https://www.soundandvision.com.br/produtos/eai-blz',
      fn: MATCHERS[:sounds].('M')
    },
    'Sorry Walt' => {
      url: 'https://www.soundandvision.com.br/produtos/sorry-walt',
      fn: MATCHERS[:sounds].('M')
    },
    'Alex Turner Transão' => {
      url: 'https://www.soundandvision.com.br/produtos/alex-turner-transao',
      fn: MATCHERS[:sounds].('M')
    },
    'Don\'t miga me' => {
      url: 'https://www.soundandvision.com.br/produtos/don-t-miga-me',
      fn: MATCHERS[:sounds].('M')
    },
    'A peleja do diabo com o dono do céu' => {
      url: 'https://www.soundandvision.com.br/produtos/a-peleja-do-diabo-com-o-dono-do-ceu',
      fn: MATCHERS[:sounds].('M')
    },
    'O diabo que te carregue' => {
      url: 'https://www.soundandvision.com.br/produtos/o-diabo-que-te-carregue',
      fn: MATCHERS[:sounds].('M')
    },
    'JAQUETA BOMBER REVERSÍVEL' => {
      url: 'http://www.lojasrenner.com.br/p/jaqueta-bomber-reversivel-542675088-542675125',
      fn: MATCHERS[:renner_new].('M')
    },
    'JAQUETA ALONGADA REVERSÍVEL' => {
      url: 'http://www.lojasrenner.com.br/p/jaqueta-alongada-reversivel-544154850-544154876',
      fn: MATCHERS[:renner_new].('M')
    },
    'JAQUETA PARKA COM CAPUZ BRANCA' => {
      url: 'http://www.lojasrenner.com.br/p/jaqueta-parka-com-capuz-543157477-543157514',
      fn: MATCHERS[:renner_new].('M')
    },
    'JAQUETA PARKA COM CAPUZ AZUL' => {
      url: 'http://www.lojasrenner.com.br/p/jaqueta-parka-com-capuz-543157477-543244600',
      fn: MATCHERS[:renner_new].('M')
    }
  }
end
