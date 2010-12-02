// 
//  plugin.js
//  mime
//  
//  Created by Peter Haza on 2010-11-15.
//  Copyright 2010 Budstikka.Media. All rights reserved.
// 
(function() {
	
	var insertDummyImage = {
		exec: function(editor) {
			var element = editor.document.createElement('img');
			element.setAttribute('contentEditable', false);
			element.setAttribute('src', 'http://dummyimage.com/200x150');
			editor.insertElement(element);
		}
	},

	insertCropZoomEditor = function(editor, element, event) {
		(function($) {
			var	img			= $(element.$),
					src			= img.attr('data-src') || img.attr('src'),
					orig_size = (img.attr('data-size') && img.attr('data-size').split('x')) || [img.width(), img.height()],
					iframe	= $(editor.element.$).next().find('iframe'),
					top			= iframe.offset().top + img.offset().top,
					left		= iframe.position().left + iframe.width() + 15,
					wrapper	= $('#image-editor').show().css({position: 'absolute', top: top, left: left}),
					crop_element	= img.clone().appendTo(wrapper.find('.container').empty()),
					cropper				= jQuery.Jcrop(crop_element, {
						trueSize: orig_size,
						minSize: [10, 10],
						maxSize: [img.width(), img.height()],
						setSelect: [0,0,img.width(), img.height()]
					});
					
				// We set this separately to get access to the cropper object
				cropper.setOptions({
					onChange: function() { // param is obj with {x, y, x2, y2, w, h}
						var selection = cropper.tellScaled();
						img.width(selection.w);
						img.height(selection.h);
					}
				});
			// Store for later editing
			img.attr('data-src', src);
			img.attr('data-width', img.width());
			img.attr('data-height', img.height());
			
			wrapper.find('[name="crop"]').click(function() {
				console.log(cropper.tellScaled());
				jQuery.post(
					'/medias/' + img.attr('data-id'),
					jQuery.extend({
						_method: 'put',
						canvas_h: img.attr('data-height'),
						canvas_w: img.attr('data-width')
						},cropper.tellScaled()
					),
					function(data, status, xhr) {
						img.attr('src', data.url);
					},
					'json'
				);
			});

			wrapper.find('[name="cancel"]').click(function() {
				cropper.destroy();
				wrapper.hide();
			});
			
		})(jQuery);
		
	},

	pluginName = 'mimeimage';

	CKEDITOR.plugins.add(pluginName, {
		lang: ['en', 'no'],

		init: function(editor) {

			editor.addCommand(pluginName, new CKEDITOR.dialogCommand(pluginName));
			CKEDITOR.dialog.add(pluginName, this.path + 'dialogs/mimeimage.js');

			// Disable crop for now
			// editor.on('doubleclick', function(evt) {
			// 	var element = evt.data.element;
			// 	if(element && element.is('img')) {
			// 		insertCropZoomEditor(editor, element, evt);
			// 	}
			// });
			
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
						if(e.type == 'mouseenter') {
							CKEDITOR.plugins[pluginName].onMouseOver(editor, this, path);
						} else {
							CKEDITOR.plugins[pluginName].onMouseOut(editor, this, path);
						}
					});
				// jQuery(imgs.$).each(function() {
				// 	CKEDITOR.plugins[pluginName].createImageToolbar(editor, this, path);
				// });
			});
			
			editor.on('change', function() {
				editor.fire('dataReady');
			});
			
			editor.on('mouseover', function(evt) {
				var el = evt.data.element;
				console.log(evt);
				if(el && element.is('img')) {
					console.log(el);
				}
			});
			
			// editor.addCommand(pluginName, insertDummyImage);
			editor.ui.addButton('MimeImage', {
				label: 'Bilde',
				command: pluginName
			});
		}
	});

	CKEDITOR.plugins[pluginName] = {
		onMouseOver: function(editor, element, path) {
			var toolbar	= jQuery('<div class="mimeimage-toolbar"/>'),
					el			= jQuery(element),
					edo			= jQuery(editor.element.$).next().find('iframe').offset();
			
			
			this.addDefaultButtons(editor.lang.mimeimage, toolbar, el, path);			

			toolbar.appendTo('body');
			el.bind('load', function() {
				var tshow = function() {
					toolbar.css({
						left: edo.left + el.offset().left,
						top: edo.top + el.offset().top - toolbar.outerHeight()
					}).show();
				};
				
				el.hover(tshow, function() { toolbar.hide(); });
				toolbar.hover(tshow, function() { toolbar.hide(); });
			});
			
		},
		onMouseOut: function(editor, element, path) {
			
		},
		addButton: function(toolbar, name, image, callback) {
			jQuery('<div title="'+name+'"/>')
				.css({backgroundImage: 'url('+image+')'})
				.click(callback)
				.appendTo(toolbar);
		},
		addDefaultButtons: function(lang, toolbar, element, path) {
			this.addButton(toolbar, lang.padding_increase, path + '/images/padding-increase.gif', function() {
				element.css('padding-top', function(i,v) {			return ((parseInt(v,10) || 0) + 1) + 'px';});
				element.css('padding-right', function(i,v) {		return ((parseInt(v,10) || 0) + 1) + 'px';});
				element.css('padding-bottom', function(i,v) {	return ((parseInt(v,10) || 0) + 1) + 'px';});
				element.css('padding-left', function(i,v) {		return ((parseInt(v,10) || 0) + 1) + 'px';});
			});
			this.addButton(toolbar, lang.padding_decrease, path + '/images/padding-decrease.gif', function() {
				element.css('padding-top', function(i,v) {			var val = parseInt(v,10) || 0;return (val > 0 ? val - 1 : 0) + 'px';});
				element.css('padding-right', function(i,v) {		var val = parseInt(v,10) || 0;return (val > 0 ? val - 1 : 0) + 'px';});
				element.css('padding-bottom', function(i,v) {	var val = parseInt(v,10) || 0;return (val > 0 ? val - 1 : 0) + 'px';});
				element.css('padding-left', function(i,v) {		var val = parseInt(v,10) || 0;return (val > 0 ? val - 1 : 0) + 'px';});
			});
			this.addButton(toolbar, lang.float_none, path + '/images/align-none.png', function() {		element.css('float', 'none');});
			this.addButton(toolbar, lang.float_left, path + '/images/align-left.png', function() {		element.css('float', 'left');});
			this.addButton(toolbar, lang.float_right, path + '/images/align-right.png', function() {	element.css('float', 'right');});
		}	
	};
})();
