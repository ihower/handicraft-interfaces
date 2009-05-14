module SingleFieldInlineEditHelper
    
  def cancel_link(title, item)
    link_to_function title do |page| 
      page.replace_html "inline-editing-#{item.id}", :partial => 'show', :locals => { :item => item}
    end 
  end
  
  
end
