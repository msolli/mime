// 
//  mimelink.js
//  mime
//  
//  Created by Peter Haza on 2010-11-16.
//  Copyright 2010 Budstikka.Media. All rights reserved.
// 

CKEDITOR.dialog.add('mimelink', function(editor) {
	return {
		title: 'Internlenke',
		minHeight: 100,
		minWidth: 400,
		onOk: function() {
			var	selectedText	= CKEDITOR.plugins.mimelink.getSelectedText(this.getParentEditor()),
					element	= CKEDITOR.plugins.link.getSelectedLink(this.getParentEditor()),
					value		= this.getContentElement('page1', 'linkInput').getValue();
			
			if(!selectedText || selectedText.length == 0) {
				selectedText = value;
			}
			
			if(element && element.is('a')) {
				element.setAttribute('href', value);
				element.setAttribute('_cke_saved_href', value);
			} else {
				selection = this.getParentEditor().getSelection();
				range 	= selection.getRanges()[0];
				element = CKEDITOR.plugins.mimelink.createLink(value, selectedText, range);
				
				range.extractContents();
				range.insertNode(element);
				
				var newRange = new CKEDITOR.dom.range(range.document);
				newRange.moveToPosition(element, CKEDITOR.POSITION_AFTER_END);
				newRange.select();
			}
			
		},
		onCancel: function() {
			// console.log('cancel');
		},
		onShow: function() {
			var that = this;

			var	selectedText	= CKEDITOR.plugins.mimelink.getSelectedText(this.getParentEditor()),
					element				= this.getParentEditor().getSelection().getStartElement(),
					infoElement		= that.getContentElement('page1', 'info').getElement();
			
			if(selectedText.length > 0) {
				CKEDITOR.plugins.mimelink.checkArticleExistence(selectedText,
					function(data) {
						// onSuccess
						infoElement.setHtml('<a target="_blank" style="text-decoration: underline; color: #00f" href="'+data.url+'">' + selectedText + '</a> finnes √');
					},
					function() {
						// onError
						infoElement.setHtml('<a target="_blank" style="text-decoration: underline; color: #f00" href="/'+encodeURIComponent(selectedText)+'">' + selectedText + '</a> finnes ikke (Og det er helt greit!)');
					}
				);
				if(element && element.is('a')) {
					this.setupContent(decodeURIComponent(element.getAttribute('href')));
				} else {
					this.setupContent(selectedText);
				}
			} else {
				infoElement.setHtml('');
			}
			
		},
		resizable: CKEDITOR.DIALOG_RESIZE_NONE,		
		contents: [
			{
				id: 'page1',
				label: 'Lenkeinstillinger',
				elements: [
					{
						id:		'info',
						type: 'html',
						html: '<p></p>'
					},
					{
						type: 'text',
						id: 'linkInput',
						label: 'Lenke',
						labelLayout: 'vertical',
						setup: function(value) {
							this.setValue(value);
						}
					}
				]
			}
		]
	};
});