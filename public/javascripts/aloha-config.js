GENTICS.Aloha.settings = {
	i18n: { current: 'en' },
	ribbon: false,
	plugins: {
		"com.gentics.aloha.plugins.Format": {
			config: ['b','i','u','del','sub','sup','p','title','h1','h2','h3','h4','h5','h6', 'pre', 'removeFormat']
		},
		'com.gentics.aloha.plugins.DragAndDropFiles': {
			config: { drop: {
					max_file_size: 10*1024*1024, // 10 MB,
					upload: {
						config: {
							url: '/medias/',
							extra_headers: {
								'X-Requested-With': 'XMLHTTPRequest',
								'X-Extuploader': true,
								accept: 'application/json',
								authenticity_token: $('meta[name=csrf-param]').attr('content') // Currently not working
							} 
						}
					}					
				}
			}
		}
	}
};

var GENTICS_Aloha_base = GENTICS.Aloha.autobase;

(function() {
	
	function save(event, eventProperties) {
		
	}
	
	function insertDefault(event, eventProperties) {
		if(/^\s*<br>\s*$/.test(eventProperties.editable.getContents())) {
			eventProperties.editable.obj.html(eventProperties.editable.obj.data('default-value'));
		}
	}
	
	function removeDefault(event, eventProperties) {
		if(/^Trykk på meg for å/i.test(eventProperties.editable.getContents())) {
			eventProperties.editable.obj.data('default-value', eventProperties.editable.getContents());
		}
	}
	
	GENTICS.Aloha.EventRegistry.subscribe(GENTICS.Aloha, 'editableDeactivated', save);
	GENTICS.Aloha.EventRegistry.subscribe(GENTICS.Aloha, 'editableDeactivated', insertDefault);
	GENTICS.Aloha.EventRegistry.subscribe(GENTICS.Aloha, 'editableActivated', removeDefault);
})();