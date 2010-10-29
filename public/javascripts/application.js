(function(){
  // if firefox 3.5+, hide content till load (or 3 seconds) to prevent FOUT
  var d = document, e = d.documentElement, s = d.createElement('style');
  if (e.style.MozTransform === ''){ // gecko 1.9.1 inference
    s.textContent = 'body{visibility:hidden}';
    e.firstChild.appendChild(s);
    function f(){ s.parentNode && s.parentNode.removeChild(s); }
    addEventListener('load',f,false);
    setTimeout(f,3000); 
  }
})();

// ECMAScript 5 trim()
if (typeof(String.prototype.trim) === "undefined") {
    String.prototype.trim = function() {
        return String(this).replace(/^\s+|\s+$/g, '');
    };
}

$(document).ready(function() {
	// Don't show presentation headword in edit article form if it's the same as
	// headword
	e = $("article form #article_headword_presentation");
	if (e.length && e.val().trim() == $("article header h1").html().trim()) {
		e.val('');
	}

	// jQuery.timeago() (http://timeago.yarp.com/)
	$.timeago.settings.cutoff = 7*24*60*60*1000;
	$("time.timeago").timeago();

	// Formtastic
	$('form.formtastic label abbr').html(function() {
		return '(' + $(this).attr('title') + ')';
	});
});
