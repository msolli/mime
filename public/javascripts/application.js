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
	var e = $("article form #article_headword_presentation");
	if (e.length) {
		var value = e.val().trim();
		var replaceChar = [[/&/g, "&amp;"], [/</g, "&lt;"], [/>/g, "&gt;"]];
		for (var i in replaceChar) {
			value = value.replace(replaceChar[i][0], replaceChar[i][1]);
		}
		if (value == $("article header h1").html().trim()) {
			e.val('');
		}
	}

	// jQuery.timeago() (http://timeago.yarp.com/)
	$.timeago.settings.cutoff = 7*24*60*60*1000;
	$("time.timeago").timeago();

	// Formtastic
	$('form.formtastic label abbr').html(function() {
		return '(' + $(this).attr('title') + ')';
	});
	
	$('[data-tooltip-enable]').tooltip({
		layout: '<div><span/></div>',
		
		onBeforeShow: function() {
			var	el		= this.getTrigger(),
					conf	= this.getConf();
			
			conf.position = ['top right'];
			conf.offset = [this.getTip().outerHeight() - 8, 25];
		}
	});
});
