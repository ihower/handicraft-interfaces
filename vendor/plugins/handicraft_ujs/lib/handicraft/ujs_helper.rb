module Handicraft
  module UjsHelper
  
  # Passes the authenticity token for use in javascript
  def yield_authenticity_token
    if protect_against_forgery?
  "<script type='text/javascript'>
    //<![CDATA[
      window._auth_token_name = '#{request_forgery_protection_token}';
      window._auth_token = '#{form_authenticity_token}';
    //]]>
  </script>"
    end
  end
    
  end
end
