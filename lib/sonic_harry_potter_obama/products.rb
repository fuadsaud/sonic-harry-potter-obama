require_relative 'matching'

module SonicHarryPotterObama
  HERING_M = MATCHERS[:hering].('M')
  SOUNDS_M = MATCHERS[:sounds].('M')
  SOUNDS_M_PRETO = MATCHERS[:sounds].('M preto')
  SOUNDS_M_PRETA = MATCHERS[:sounds].('M preta')
  SOUNDS_M_BRANCA = MATCHERS[:sounds].('M branca')
  RENNER_M = MATCHERS[:renner].('M')

  TABLE = [
    'Hering Jogger Branca',                HERING_M,        'https://www.hering.com.br/store/pt/p/calca-masculina-basica-jogger-em-moletom-peluciado-hering-05M3M2H07S4',
    'Hering Jogger Preta',                 HERING_M,        'https://www.hering.com.br/store/pt/p/calca-masculina-basica-jogger-em-moletom-peluciado-hering-05M3N1007S5',
    'Grande Acordo Nacional',              SOUNDS_M_PRETO,  'https://www.soundandvision.com.br/produtos/grande-acordo-nacional',
    'Tudo Muito Dark',                     SOUNDS_M_PRETA,  'https://www.soundandvision.com.br/produtos/udo-mui-o-dark-udo-mui-o-dark',
    'O Caminho do Bem',                    SOUNDS_M,        'https://www.soundandvision.com.br/produtos/o-caminho-do-bem',
    'Dinossaur Jr.',                       SOUNDS_M,        'https://www.soundandvision.com.br/produtos/feel-the-pain',
    'Washing Machine',                     SOUNDS_M,        'https://www.soundandvision.com.br/produtos/washing-machine',
    'Space Oddity',                        SOUNDS_M_BRANCA, 'https://www.soundandvision.com.br/produtos/space-oddity',
    'Coma Churros',                        SOUNDS_M,        'https://www.soundandvision.com.br/produtos/coma-churros',
    'Batiminha LP',                        SOUNDS_M,        'https://www.soundandvision.com.br/produtos/batiminha-lp',
    'Batiminha',                           SOUNDS_M,        'https://www.soundandvision.com.br/produtos/batiminha',
    'The Dark Side of Batiminha',          SOUNDS_M,        'https://www.soundandvision.com.br/produtos/the-dark-side-of-batiminha',
    'Who the fuck is Batiminha',           SOUNDS_M,        'https://www.soundandvision.com.br/produtos/who-the-fuck',
    'DAMN',                                SOUNDS_M,        'https://www.soundandvision.com.br/produtos/damn',
    'Mac Demarco',                         SOUNDS_M,        'https://www.soundandvision.com.br/produtos/mac-demarco',
    '1000 tretas',                         SOUNDS_M,        'https://www.soundandvision.com.br/produtos/1000-tretas',
    'Coltrane',                            SOUNDS_M,        'https://www.soundandvision.com.br/produtos/coltrane-8eb518cb-8d9e-48ad-9acb-570d2ace2282',
    'Coltrane Africa',                     SOUNDS_M,        'https://www.soundandvision.com.br/produtos/coltrane-073e6c81-d94b-476e-9006-97fc73920cfb',
    'Que Deus perdoe essas pessoas',       SOUNDS_M,        'https://www.soundandvision.com.br/produtos/que-deus-perdoe-essas-pessoas-que-deus-gg',
    'Que Deus nunca perdoe essas pessoas', SOUNDS_M,        'https://www.soundandvision.com.br/produtos/que-deus-nunca-perdoe-essas-pessoas-e75a11ee-dc89-4f67-a05e-6dc7976cd97c',
    'Antifa',                              SOUNDS_M,        'https://www.soundandvision.com.br/produtos/antifa',
    'Obama',                               SOUNDS_M,        'https://www.soundandvision.com.br/produtos/obama-caa73265-f39e-42bb-8c29-d67af76a14d7',
    'Esto no es America',                  SOUNDS_M,        'https://www.soundandvision.com.br/produtos/this-is-not-america',
    "Boys Don't Cry",                      SOUNDS_M,        'https://www.soundandvision.com.br/produtos/boys-don-t-cry',
    'Ewok',                                SOUNDS_M,        'https://www.soundandvision.com.br/produtos/ewok-f4e70741-e047-47f8-880b-c4200c2ada62',
    'E aí blz?',                           SOUNDS_M,        'https://www.soundandvision.com.br/produtos/eai-blz',
    'Sorry Walt',                          SOUNDS_M,        'https://www.soundandvision.com.br/produtos/sorry-walt',
    'Alex Turner Transão',                 SOUNDS_M,        'https://www.soundandvision.com.br/produtos/alex-turner-transao',
    "Don't miga me",                       SOUNDS_M,        'https://www.soundandvision.com.br/produtos/don-t-miga-me',
    'A peleja do diabo com o dono do céu', SOUNDS_M,        'https://www.soundandvision.com.br/produtos/a-peleja-do-diabo-com-o-dono-do-ceu',
    'O diabo que te carregue',             SOUNDS_M,        'https://www.soundandvision.com.br/produtos/o-diabo-que-te-carregue',
    'JAQUETA BOMBER REVERSÍVEL',           RENNER_M,        'http://www.lojasrenner.com.br/p/jaqueta-bomber-reversivel-542675088-542675125',
    'JAQUETA ALONGADA REVERSÍVEL',         RENNER_M,        'http://www.lojasrenner.com.br/p/jaqueta-alongada-reversivel-544154850-544154876',
    'JAQUETA PARKA COM CAPUZ BRANCA',      RENNER_M,        'http://www.lojasrenner.com.br/p/jaqueta-parka-com-capuz-543157477-543157514',
    'JAQUETA PARKA COM CAPUZ AZUL',        RENNER_M,        'http://www.lojasrenner.com.br/p/jaqueta-parka-com-capuz-543157477-543244600'
  ]

  PRODUCTS = TABLE.each_slice(3).map { |name, matcher, url| { name: name, url: url, fn: matcher } }
end
