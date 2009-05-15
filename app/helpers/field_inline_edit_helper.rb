module FieldInlineEditHelper
    
  def cancel_link(title, item)
    link_to_function title do |page| 
      page.replace_html dom_id(item, :inline_edit), :partial => 'show', :locals => { :item => item}
    end 
  end
  
  
end
