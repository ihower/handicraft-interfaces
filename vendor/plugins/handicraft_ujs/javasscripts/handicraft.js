// -*- javascript-indent-level: 2 -*-
(function($) {
    $.ajaxSettings.accepts._default = "text/javascript, text/html, application/xml, text/xml, */*";
     
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
      
      // All A tags with class 'h-get', 'h-post', 'h-put' or 'h-delete' will perform an ajax call
      $('a.h-get').live('click', function() {
        if ( $(this).metadata().update ) {
            $("#"+$(this).metadata().update).load( $(this).attr('href') );
        } else if ( $(this).metadata().callback ) {
            $.getJSON( $(this).attr('href'), null, eval( $(this).metadata().callback ) );
        } else {
            $.getScript($(this).attr('href') );
        }
        return false;
      });

      $("a.h-post, a.h-put, a.h-delete").live("click", function(e) {
        var method = $(e.target).attr("class").match(/h-(post|put|delete)/i)[1].toLowerCase();
        var $el = $(e.target);

        if ($el.metadata().confirm && !confirm($el.metadata().confirm)) return false;

        if ( $el.metadata().callback ) {
          $.post($el.attr('href'), "_method=" + method, eval( $el.metadata().callback ), 'json');
        } else {
          $.post($el.attr('href'), "_method=" + method, null, 'script');
        }

        return false;
      });

      // All form tags
      $("form.h-post, form.h-put, form.h-delete, form.h-get").live("submit", function(e) {
        var method = $(e.target).attr("class").match(/h-(get|post|put|delete)/i)[1].toLowerCase();
        $(e.target).ajaxSubmit({ dataType:  'script', type: method });
        return false;
      });

      // All input tags      
      $("input.h-post, input.h-put, input.h-delete, input.h-get").live("click", function(e){
        var method = $(e.target).attr("class").match(/h-(get|post|put|delete)/i)[1].toLowerCase();
        $(e.target).parents('form:first').ajaxSubmit({ dataType:  'script', type: method });
        return false;
      });
      
    });
})(jQuery);