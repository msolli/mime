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
    // Load user data for navigation links.
    // On cached pages the user data is retrieved by ajax.
    // On dynamic pages the user data will be present as HTML5 data attributes
    (function(){
        // Parse template and append to #user-links
        var addUserData = function(data) {
            $('#user-links-tmpl').tmpl(data).appendTo('#user-links');
        };

        var userData = $('#user-links').data('user');
        if (userData === undefined) {
            $.ajax({
                type: 'GET',
                dataType: 'json',
                url: '/users/current',
                success: addUserData
            });
        } else {
            addUserData(userData);
        }
    })();

	// Don't show presentation headword in edit article form if it's the same as
	// headword
    (function(){
    	var headword_presentation = $("article form #article_headword_presentation");
    	var headword = $("article form #article_headword");
    	if (headword_presentation.length && headword.length) {
    		if (headword_presentation.val().trim() == headword.val().trim()) {
    			headword_presentation.val('');
    		}
    	}
	})();

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
			conf.offset = [this.getTip().outerHeight(), 10];
		}
	});
	$('li.error [data-tooltip-enable]').focus();
	
	// Disable enter to submit for map search
	$('#maptastic-search').keypress(function(e) {
		if(e.keyCode == '13') {
			e.preventDefault();
			e.stopPropagation();
			return false;
		}
	});
});
