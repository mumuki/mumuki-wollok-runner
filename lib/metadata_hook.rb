class MetadataHook < Mumukit::Hook
  def metadata
    {language: {
        name: 'wollok',
        icon: {type: 'devicon', name: 'haskell'},
        version: '1.3',
        extension: 'wlk',
        ace_mode: 'wollok'
    },
     test_framework: {
         name: 'builtin',
         test_extension: 'wtest'
     }}
  end
end