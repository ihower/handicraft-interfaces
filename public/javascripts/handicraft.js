(function($) {
    $.ajaxSettings.accepts._default = "text/javascript, text/html, application/xml, text/xml, */*";
})(jQuery);


// Behaviours
$(document).ready(function() {
  // All non-GET requests will add the authenticity token
  // if not already present in the data packet
  $("body").bind("ajaxSend", function(elm, xhr, s) {
    if (s.type == "GET") return;
    if (s.data && s.data.match(new RegExp("\\b" + window._auth_token_name + "="))) return;
    if (s.data) {
      s.data = s.data + "&";
    } else {
      s.data = "";
      // if there was no data, jQuery didn't set the content-type
      xhr.setRequestHeader("Content-Type", s.contentType);
    }
    s.data = s.data + encodeURIComponent(window._auth_token_name)
                    + "=" + encodeURIComponent(window._auth_token);
  });
});

// More behaviours
$(document).ready(function() {
  // All A tags with class 'h-get', 'h-post', 'h-put' or 'h-delete' will perform an ajax call
  $('a.h-get').live('click', function() {
    
    if ( $(this).metadata().update ) {
        $("#"+$(this).metadata().update).load( $(this).attr('href') );
    } else if ( $(this).metadata().callback ) {
        $.getJSON( $(this).attr('href'), undefined, eval( $(this).metadata().callback ) );
    } else {
        $.getScript($(this).attr('href') );
    }
    
    return false;
  }).attr("rel", "nofollow");

  ['h-post', 'h-put', 'h-delete'].forEach(function(method) {
    $('a.' + method).live('click', function() {
      if ($(this).metadata().confirm && !confirm($(this).metadata().confirm)) return false;
      
      if ( $(this).metadata().callback ) {
          $.post($(this).attr('href'), "_method=" + method, eval( $(this).metadata().callback ), 'json');
      } else {
          $.post($(this).attr('href'), "_method=" + method, undefined, 'script');
      }
      
      return false;
    }).attr("rel", "nofollow");
  });
});