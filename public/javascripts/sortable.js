$(document).ready(function() {
  $('#article-lists').sortable({
    cancel: 'span',
    cursor: 'move',
    handle: 'h2',
    items: 'li.article_list',
    opacity: 0.6,
    update: function(event, ui) {
      $(this).children('li').each(function(index) {
        $(this).find('input[type=hidden].position').val(index);
        console.log(index);
      });
    }
  });
  $('#article-lists').disableSelection();
});
