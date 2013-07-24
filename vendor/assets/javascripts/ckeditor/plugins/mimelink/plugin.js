// 
//  plugin.js
//  mime
//  
//  Created by Peter Haza on 2010-11-15.
//  Copyright 2010 Budstikka.Media. All rights reserved.
// 

CKEDITOR.plugins.add('mimelink', {
	init: function(editor) {
		var pluginName = 'mimelink';
		
		editor.addCommand(pluginName, new CKEDITOR.dialogCommand(pluginName));
		editor.addCommand( 'mime_unlink', new CKEDITOR.unlinkCommand() );

		editor.on('doubleclick', function(evt) {
			var element = CKEDITOR.plugins.link.getSelectedLink() || evt.data.element;
			if(element && element.is('a')) {
				evt.data.dialog = pluginName;
			}
		});
		
		editor.on( 'selectionChange', function( evt )
			{
				// From link plugin
				var command = editor.getCommand( 'mime_unlink' ),
					element = evt.data.path.lastElement && evt.data.path.lastElement.getAscendant( 'a', true );
				if ( element && element.getName() == 'a' && element.getAttribute( 'href' ) )
					command.setState( CKEDITOR.TRISTATE_OFF );
				else
					command.setState( CKEDITOR.TRISTATE_DISABLED );
			} );
		
		editor.ui.addButton('MimeLink', {
			label: 'Lag lenke',
			command: pluginName,
			icon: this.path + 'images/link.png'
		});
		
		// From link plugin
		// editor.addCommand( 'unlink', new CKEDITOR.unlinkCommand() );		
		editor.ui.addButton( 'Unlink',
		{
			label : editor.lang.unlink,
			command : 'mime_unlink',
			icon: this.path + 'images/unlink.png'
		} );
		
		CKEDITOR.dialog.add(pluginName, this.path + 'dialogs/mimelink.js');
	}
});

CKEDITOR.plugins.mimelink = {
	getSelectedText: function(editor) {
		var	selection	= editor.getSelection(),
				text			= CKEDITOR.env.ie ? selection.getNative().createRange().text : selection.getNative().toString();
				
		return text;
	},
	createLink: function(url, text, range) {
		var element = CKEDITOR.dom.element.createFromHtml('<a href="'+ url+'">'+text+'</a>');
		range.extractContents();
		range.insertNode(element);
		return element;
	},
	search: function(text, onResult) {
		jQuery.getJSON('/fastsearch', {
			model: 'article',
			query: text,
			num: 5,
			qfields: 'headword',
			rfields: 'headword'
		}, onResult);
	},
	checkArticleExistence: function(text, onSuccessFn, onErrorFn) {
		jQuery.ajax({
			url: '/' + text,
			dataType: 'json',
			error: onErrorFn,
			success: onSuccessFn
		});
	}	
};

