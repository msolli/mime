var mime = mime || {};
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

     new_li.find('input').each(function() { $(this).val(""); } );

     new_li.insertAfter(li);
		return new_li;
	}
};
