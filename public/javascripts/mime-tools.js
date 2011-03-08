var mime = mime || {};
mime.t = function(scope) {
	var scopes = scope.split('.'),
			current = mime.translations,
			fail = false;
	if(current) {
		for (var i=0; i < scopes.length; i++) {
			var s = scopes[i];
			if(current[s]) current = current[s];
			else { fail = true; break; }
		}
	}
	return !fail ? current :  'Translation missing: ' + scope;	
};

mime.tools = {
	input_cloner: function(li) {
		var new_li = li.clone(true);

     new_li.find('*[for],*[id]').andSelf().each(function() {
       var that = this;
       $.each(['for', 'id', 'name'], function(key, value) {
         var att = $(that).attr(value);
         if(att) {
           att = att.replace(/(\d+)/, function(all, group_1) {
             return (parseInt(group_1, 10) + 1);
           });

           $(that).attr(value, att);
         }
       });
     });

     new_li.find('input, textarea').each(function() { $(this).val(""); } );

     new_li.insertAfter(li);
		return new_li;
	},

  addDatepicker: function(element) {
    $(element).not(function(){
      return ($(this).parents('#jstemplates').length > 0);
    }).datepicker({ dateFormat: 'yy-mm-dd' });
  }
};
