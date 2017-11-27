class WollokMetadataHook < Mumukit::Hook
  def metadata
    {language: {
        name: 'wollok',
        icon: {type: 'devicon', name: 'wollok'},
        version: '1.5',
        extension: 'wlk',
        ace_mode: 'wollok'
    },
     test_framework: {
         name: 'builtin',
         test_extension: 'wtest',
         template: <<wollok
describe "{{ test_template_group_description }}"{
	test "{{ test_template_sample_description }}" {
		assert.that(true)
	}
}
wollok
     }}
  end
end