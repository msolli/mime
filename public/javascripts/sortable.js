$(document).ready(function() {
  $('#article-lists').sortable({
    cursor: 'move',
    handle: 'h2',
    items: 'li.article_list',
    opacity: 0.6,
    placeholder: "article_list_placeholder ui-state-highlight",
    update: function(event, ui) {
      $(this).children('li').each(function(index) {
        $(this).find('input[type=hidden].position').val(index);
      });
    }
  });
  $('#article-lists h2').disableSelection().css('cursor', 'move');
});
