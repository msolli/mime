// 
//  plugin.js
//  mime
//  
//  Created by Peter Haza on 2010-11-15.
//  Copyright 2010 Budstikka.Media. All rights reserved.
// 
(function() {

	pluginName = 'mimeimage';

	CKEDITOR.plugins.add(pluginName, {
		requires: ['fakeobjects'],
		lang: ['en', 'no'],

		init: function(editor) {

			editor.addCommand(pluginName, new CKEDITOR.dialogCommand(pluginName));
			CKEDITOR.dialog.add(pluginName, this.path + 'dialogs/mimeimage.js');
			CKEDITOR.dialog.add(pluginName + 'caption', this.path + 'dialogs/mimeimagecaption.js');

			editor.on('doubleclick', function(evt) {
				var element = evt.data.element;
				if(element && element.is('img') && element.getAttribute( '_cke_real_element_type' ) == 'figure') {
					evt.data.dialog = pluginName + 'caption';
				}
			});
			
			var path = this.path;
			
				editor.on('dataReady', function(evt) {
					// Disable image drag
					editor.document.on('dragstart', function(evt) {
						if(evt.data.$.target.nodeName.toLowerCase() == 'img') {
							if(evt.data.$.preventDefault) {
								evt.data.$.preventDefault();
							} else {
								evt.data.$.returnValue = false;
							}
						}
					});
					
					var body = editor.document.getElementsByTag('body');

					jQuery(body.$).delegate('img', 'hover', function(e) {
						CKEDITOR.plugins[pluginName].toolbar.addHover(editor, this, path);
					});
				// jQuery(imgs.$).each(function() {
				// 	CKEDITOR.plugins[pluginName].createImageToolbar(editor, this, path);
				// });
			});

			editor.on('change', function() {
				editor.fire('dataReady');
			});

			// editor.addCommand(pluginName, insertDummyImage);
			editor.ui.addButton('MimeImage', {
				label: 'Bilde',
				command: pluginName
			});			
		},
		afterInit: function(editor) {
			var dataProcessor = editor.dataProcessor,
				dataFilter = dataProcessor && dataProcessor.dataFilter;

			if ( dataFilter )
			{
				dataFilter.addRules({
					elements: {
						figure: function(element) {
							for (var i = element.children.length - 1; i >= 0; i--){
								var c = element.children[i];
								if(c.name == 'img') {
									return CKEDITOR.plugins[pluginName].createFakeParserElement(
										editor,
										element,
										c.attributes['data-thumbsize'] || '200x180');
								}
							}
							return null;
						}
					}
				}, 5);
			}
		}
	});

	CKEDITOR.plugins[pluginName] = {
		getRealImageSrcFromFakeParserElement: function(element) {
			for (var i = element.children.length - 1; i >= 0; i--){
				var e = element.children[i];
				if(e.name == 'img') {
					return e.attributes['src'];
				}
			}
			
			return null;
		},
		getRealImageSrcFromFakeElement: function(element) {
			for (var i = element.getChildCount() - 1; i >= 0; i--){
				var e = element.getChild(i);
				if(e.getName() == 'img') {
					return e.getAttribute('src');
				}
			}
			
			return null;
		},
		createFakeElement: function(editor, real_element, size) {
			var el = editor.createFakeElement(real_element, 'cke_figure', 'figure', false),
					asize = size.split('x');
			
			el.$.setAttribute('style', real_element.getAttribute('style'));
			el.$.src = this.getRealImageSrcFromFakeElement(real_element);
			
			return el;
		},
		createFakeParserElement: function(editor, real_element, size) {
			var el = editor.createFakeParserElement(real_element, 'cke_figure', 'figure', false),
					asize = size.split('x');
			
			el.attributes.style = real_element.attributes['style'];
			el.attributes.src = this.getRealImageSrcFromFakeParserElement(real_element);
			
			return el;
		},
		toolbar: {
			editor: null,
			element: null,
			path: null,
			updateFloat: function(fake_element, value) {
				var element = this.editor.restoreRealElement(fake_element),
						fake_element_dom = new CKEDITOR.dom.element(fake_element);
				element.setStyle('float', value);
				
				fake_element_dom.setAttribute('_cke_realelement', encodeURIComponent(element.getOuterHtml()));
				fake_element_dom.setStyle('float', value);
			},			
			addHover: function(editor, element, path) {
				this.editor		= editor;
				this.element	= element;
				this.path			= path;
				this.jElement	= jQuery(element);
				
				var	toolbar = this.getToolBar(),
						edo	= jQuery(editor.element.$).next().find('iframe').offset(),
						that = this,
						show = function() {
							toolbar.css({
								left: edo.left + that.jElement.offset().left,
								top: edo.top + that.jElement.offset().top - toolbar.outerHeight()
							}).show();
						},
						hide = function() {
							toolbar.hide();
						};
			
				this.jElement.hover(show, hide);
				toolbar.hover(show, hide);
			
			},
			createToolBar: function() {
				var toolbar	= jQuery('<div class="mimeimage-toolbar">');
					
				this.addDefaultButtons(this.editor.lang.mimeimage, toolbar);
				toolbar.appendTo('body').hide();
			
				return toolbar;
			},
			getToolBar: function() {
				var key = 'mimeimage-toolbar',
						t = this.jElement.data(key);
				if(!t) {
					t = this.createToolBar();
					this.jElement.data(key, t);
				}
			
				return t;
			},
			addButton: function(toolbar, name, image, callback) {
				jQuery('<div title="'+name+'"/>')
					.css({backgroundImage: 'url('+image+')'})
					.click(callback)
					.appendTo(toolbar);
			},
			addDefaultButtons: function(lang, toolbar) {
				// this.addButton(toolbar, lang.padding_increase, path + '/images/padding-increase.gif', function() {
				// 	element.css('padding-top', function(i,v) {			return ((parseInt(v,10) || 0) + 1) + 'px';});
				// 	element.css('padding-right', function(i,v) {		return ((parseInt(v,10) || 0) + 1) + 'px';});
				// 	element.css('padding-bottom', function(i,v) {	return ((parseInt(v,10) || 0) + 1) + 'px';});
				// 	element.css('padding-left', function(i,v) {		return ((parseInt(v,10) || 0) + 1) + 'px';});
				// });
				// this.addButton(toolbar, lang.padding_decrease, path + '/images/padding-decrease.gif', function() {
				// 	element.css('padding-top', function(i,v) {			var val = parseInt(v,10) || 0;return (val > 0 ? val - 1 : 0) + 'px';});
				// 	element.css('padding-right', function(i,v) {		var val = parseInt(v,10) || 0;return (val > 0 ? val - 1 : 0) + 'px';});
				// 	element.css('padding-bottom', function(i,v) {	var val = parseInt(v,10) || 0;return (val > 0 ? val - 1 : 0) + 'px';});
				// 	element.css('padding-left', function(i,v) {		var val = parseInt(v,10) || 0;return (val > 0 ? val - 1 : 0) + 'px';});
				// });
				var that = this;
				this.addButton(toolbar, lang.float_none, this.path + '/images/align-none.png', function() {		that.updateFloat(that.element, 'none');});
				this.addButton(toolbar, lang.float_left, this.path + '/images/align-left.png', function() {		that.updateFloat(that.element, 'left');});
				this.addButton(toolbar, lang.float_right, this.path + '/images/align-right.png', function() {	that.updateFloat(that.element, 'right');});
			}	
		}
	};
})();
