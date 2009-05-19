module HandicraftHelper
  
  def navigation_menu
    menu = Handicraft::Helper::Menu.new
    menu << [ "handicraft_helper Usage demo", handicraft_path, { :title => "handicraft_helper Usage demo", :id => "h-helper-nav" } ]
    menu << [ "handicraft_ujs Usage demo" , people_path, { :title => "handicraft_ujs Usage demo", :id => "h-ujs-nav" } ]
    menu << [ "Single-Field Inline Edit" , fie1_items_path ]
    menu << [ "Multi-Field Inline Edit", fie2_items_path ]
    menu << [ "Group Edit and Sortable List", ge1_items_path ]
    return menu
  end
  
  def build_table_optios
    attrs = Array.new
    attrs << ["Name", lambda{ |i| i.name } ]
    attrs << ["Conditional column", lambda{ |i| i.id }] if rand(3) % 2 == 0 
    attrs << ["Action", lambda{ |i| 
                            link_to('Show', '#' ) + ' | ' +
                            link_to('Edit', '#' )
                          }]
    return attrs
  end
  
   # breadcrumb
   def breadcrumb_from_some_place( *crumb )
     breadcrumb( link_to("Welcome", root_path),
                 link_to('First place', fie1_items_path),
                 link_to('Second place', fie2_items_path),
                 crumb.join(' &gt; ') )
   end

end
