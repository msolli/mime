var mime = mime || {};

mime.wysiwyg = function(elements) {
	this.elements = jQuery(elements);
	
	this.setup();
};

mime.wysiwyg.prototype.setup = function() {
	var e = null;
	this.elements.each(function(index) {
		e = jQuery(this);
		jQuery('<div/>', {
			id: e.attr('name'),
			'class': e.attr('class')
		}).insertBefore(e.hide()).append(e.val()).aloha();
	});
	
	GENTICS.Aloha.EventRegistry.subscribe(GENTICS.Aloha, 'editableDeactivated', this.update_form_func());
};

mime.wysiwyg.prototype.update_form_func = function() {
	return function(event, eventProperties) {
		var	editable = eventProperties.editable,
				input = jQuery('*[name='+editable.obj.attr('id')+']');

		input.val(editable.getContents());
	};
};

