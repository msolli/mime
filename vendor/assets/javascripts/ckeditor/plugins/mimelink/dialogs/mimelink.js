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
			var	selectedText	= this.getContentElement('page1', 'info').getValue(),
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
			$('.search-completion').hide();
		},
		onCancel: function() {
			// console.log('cancel');
			$('.search-completion').hide();
		},
		onShow: function() {
			var that = this;

			var	selectedText	= CKEDITOR.plugins.mimelink.getSelectedText(this.getParentEditor()),
					element				= this.getParentEditor().getSelection().getStartElement(),
					infoElement		= jQuery(that.getContentElement('page1', 'info').getElement().$),
					linkInputElement = that.getContentElement('page1', 'linkInput'),
					searchTimer		= null,
					tmpl = '<li data-url="${url}">${headword}</li>';
			
			
			infoElement.find('input').focus(function() { jQuery('.search-completion').show(); });
			
			infoElement.keyup(function() {
				if(searchTimer != null) {
					clearTimeout(searchTimer);
				}
				searchTimer = setTimeout(function() {
					
					if(jQuery('.search-completion').length == 0) {
						jQuery('<ul class="search-completion">').css({
							left: infoElement.position().left,
							top: infoElement.position().top + infoElement.height() + 2,
							width: infoElement.width()
						}).appendTo('table.cke_dialog').hide();
					}
					
					var ul = jQuery('.search-completion');
					
					ul.empty().append('<li>Søker…</a>');
					CKEDITOR.plugins.mimelink.search(infoElement.find('input').val(), function(res) {
						ul.empty().show();
						if(res.length < 1) {
							ul.append('<li>Ingen treff</li>');
						}
						for (var i=0; i < res.length; i++) {
							var li = jQuery.tmpl(tmpl, res[i]).click(function() {
								linkInputElement.setValue($(this).data('url'));
								ul.hide();
							});
							li.appendTo(ul);
						};
						
						jQuery('<span>').click(function(e) {
							e.preventDefault();
							e.stopPropagation();
							ul.hide();
						}).prependTo(ul.find('li:first'));
						
						
						clearTimeout(searchTimer);
						searchTimer = null;
					});
					
				}, 300);
			});
			
			if(selectedText.length > 0) {
				this.setupContent(selectedText);
				jQuery(infoElement).trigger('keyup');
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
						type: 'text',
						label: 'Lenketekst',
						setup: function(value) {
							this.setValue(value);
						}
					},
					{
						type: 'text',
						id: 'linkInput',
						label: 'Lenke',
						labelLayout: 'vertical'
					}
				]
			}
		]
	};
});