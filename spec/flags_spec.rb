require_relative '../lib/wollok_server'

describe 'flags' do
  let(:flags) { Flags.new }

  it { expect(flags.flags('')).to eq [] }
  it { expect(flags.flags('foobar')).to eq [] }
  it { expect(flags.flags('/*Zaraza*/')).to eq [] }
  it { expect(flags.flags('/*[Zaraza]*/')).to eq %w(Zaraza) }
  it { expect(flags.flags('/*[Zaraza]*//*[Zarlanga]*/')).to eq %w(Zaraza Zarlanga) }

  it { expect(flags.transform(content: 'content',
                              extra: 'extra',
                              query: 'query')).to eq content: 'content', extra: 'extra', query: 'query' }

  it { expect(flags.transform(content: 'content',
                              extra: '/*[IgnoreContentOnQuery]*/ extra',
                              query: 'query')).to eq extra: '/*[IgnoreContentOnQuery]*/ extra', query: 'query' }

end


# interpolaciones
# ...algo...     inclusion

# secciones
# <algo#  #algo> seccion

# banderas
# [Flag]         activar flag