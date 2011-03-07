$(document).ready(function() {
  // Adding / removing nested objects in nested forms
  (function() {
    $('form a.add_child').click(function() {
      var association = $(this).attr('data-association');
      var template = $('#' + association + '_fields_template').html();
      var regexp = new RegExp('new_' + association, 'g');
      var newId = new Date().getTime();

      $(template.replace(regexp, newId)).insertBefore($(this).parent());

      mime.tools.addDatepicker('.date-field');
      $('.headword-autocomplete').autocomplete(mime.headwordAutocomplete).focus();

      return false;
    });

    $('form a.remove_child').live('click', function() {
      var hiddenField = $(this).prev('input[type=hidden]')[0];
      if (hiddenField) {
        hiddenField.value = '1';
      }
      $(this).parents('.fields').css('visibility', 'hidden').slideUp('fast');
      return false;
    });

    $('form a.remove_list').live('click', function() {
      var parent = $(this).parents('.article_list');
      var hiddenField = parent.find('input[type=hidden]')[0];
      if (hiddenField) {
        hiddenField.value = '1';
      }
      parent.find('ul').css('visibility', 'hidden').slideUp('fast');
      parent.find('.actions').hide();
      parent.find('.deleted').show();

      // If we remove an item, we want it to remain gone after a page reload. This is
      // accomplished by storing the link id, and triggering these links again
      // when the page is (re-)loaded.
      if (supportsSessionStorage()) {
        var id = $(this).attr('id');
        var removeLists = JSON.parse(sessionStorage['removeLists'] || "[]");
        if ($.inArray(id, removeLists) < 0) {
          removeLists.push(id);
        }
        sessionStorage['removeLists'] = JSON.stringify(removeLists);
      }

      return false;
    });

    $('form a.undo_remove_list').live('click', function() {
      var parent = $(this).parents('.article_list');
      var hiddenField = parent.find('input[type=hidden]')[0];
      if (hiddenField) {
        hiddenField.value = '0';
      }
      parent.find('ul').css('visibility', 'visible').slideDown();
      parent.find('.actions').show();
      parent.find('.deleted').hide();

      // Remove this item from the list of links to be triggered after page reload.
      if (supportsSessionStorage()) {
        var id = $(this).attr('id');
        var removeLists = JSON.parse(sessionStorage['removeLists'] || "[]");
        removeLists.splice($.inArray(id, removeLists), 1);
        sessionStorage['removeLists'] = JSON.stringify(removeLists);
      }

      return false;
    });

    // Trigger links for removing items
    if (supportsSessionStorage()) {
      var removeLists = JSON.parse(sessionStorage['removeLists'] || "[]");
      for (i in removeLists) {
        $('#' + removeLists[i]).click();
      }
    }
  })();

  // Adding / removing external links
	(function() {
		$('#external-links').find('button').click(function() {
	    var li = $(this).closest('ol').parent();

	    if ($(this).hasClass('add')) {
	      mime.tools.input_cloner(li);
	    } else if ($(this).hasClass('remove')) {
	      if (!li.is(':only-child')) {
	        li.remove();
	      }
	    }
	  });
	})();
});