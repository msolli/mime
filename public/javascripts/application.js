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

$(document).ready(function() {
	// Don't show presentation headword in edit article form if it's the same as
	// headword
	e = $("article #article_headword_presentation");
	if (e.val() == $("article h1").html()) {
		e.val('');
	}
});
