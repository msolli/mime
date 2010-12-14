// 
//  mimeimagecaption.js
//  mime
//  
//  Created by Peter Haza on 2010-12-14.
//  Copyright 2010 Budstikka.Media. All rights reserved.
// 

CKEDITOR.dialog.add('mimeimagecaption', function(editor) {
	
	var	lang = editor.lang.mimeimage,
			update_caption = function(editor, element, value) {
				var real_element = editor.restoreRealElement(element);
				for (var i = real_element.getChildCount() - 1; i >= 0; i--){
					var e = real_element.getChild(i);
					if(e.getName() == 'figurecaption') {
						e.setText(value);
					}
				}
				
				element.setAttribute('_cke_realelement', encodeURIComponent(real_element.getOuterHtml()));				
			},
			get_caption = function(editor, element) {
				var real_element = editor.restoreRealElement(element);
				for (var i = real_element.getChildCount() - 1; i >= 0; i--){
					var e = real_element.getChild(i);
					if(e.getName() == 'figurecaption') {
						return e.getText();
					}
				}
				
				return '';
			};

	return {
		title: 'Bildetekst',
		minHeight: 100,
		minWidth: 400,
		contents: [
			{
				id: 'page1',
				label: lang.caption_label,
				elements: [
					{
						id:		'caption',
						label: lang.caption_label,
						type: 'text'
					}
				]
			}
		],
		resizable: CKEDITOR.DIALOG_RESIZE_NONE,
		onOk: function() {
			var editor = this.getParentEditor(),
					element = editor.getSelection().getStartElement(),
					caption_container = this.getContentElement('page1', 'caption');
					
			update_caption(editor, element, caption_container.getValue());
		},
		onShow: function() {
			var	editor	= this.getParentEditor(),
					element	= editor.getSelection().getStartElement(),
					caption_container = this.getContentElement('page1', 'caption');
			
			caption_container.setValue(get_caption(editor, element));
		}
	};
});