class WollokMetadataHook < Mumukit::Hook
  def metadata
    {language: {
        name: 'wollok',
        icon: {type: 'devicon', name: 'code'},
        version: '1.5',
        extension: 'wlk',
        ace_mode: 'wollok'
    },
     test_framework: {
         name: 'builtin',
         test_extension: 'wtest'
     }}
  end
end