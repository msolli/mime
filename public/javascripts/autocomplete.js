$(document).ready(function() {
  mime.headwordAutocomplete = {
    source: function(request, response) {
      $.getJSON('/fastsearch', {
        model: 'article',
        query: request.term,
        qfields: 'headword',
        rfields: 'headword',
        num: 5
      },
      function(data) {
        response($.map(data, function(item) {
          return item.headword;
        }));
      });
    },
    minLength: 2
  };
  $('.headword-autocomplete').autocomplete(mime.headwordAutocomplete);
});
