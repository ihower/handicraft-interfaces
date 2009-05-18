module Handicraft
  module Helper
  
  unless const_defined? :SITE_NAME
    SITE_NAME = "undefined"
  end
  
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
    
  def breadcrumb( *crumb )
    p = TagNode.new( :p, :class => "breadcrumb" )
    p << crumb.join(' &gt; ')
    return p.to_s
  end
  
  def render_page_title
    title = @page_title ? "#{SITE_NAME} | #{@page_title}" : SITE_NAME
    content_tag("title", title)
  end
  
  def render_body_tag
    tag_class ="#{controller_name}-controller #{action_name}-action"
    
    if @body_id
      %Q{<body id="#{@body_id}-page" class="#{tag_class}">}
    else
      %Q{<body class="#{tag_class}">}
    end
  end
  
  def s(html)
    sanitize( html, :tags => %w(table thead tbody tr td th ol ul li div span font img sup sub br hr a pre p h1 h2 h3 h4 h5 h6), :attributes => %w(id class style src href size color) )
  end
  
  def render_table(rows, renderrers, table_options = {})
    table_options = {
      :has_header => true,
      :has_row_info => false,
      :id => nil,
      :class_name => "auto"
      }.merge(table_options)

    table_tag_options = table_options[:id] ? { :id => table_options[:id], :class => table_options[:class_name] } : { :class => table_options[:class_name] }
    
    table = TagNode.new('table', table_tag_options)
    if table_options[:has_header] == true
      table << thead = TagNode.new(:thead) 
      thead << tr = TagNode.new(:tr, :class => 'odd')
       
      renderrers.each do |renderrer| 
        tr << th = TagNode.new(:th)
        th << renderrer[0]
      end
    end    
    
    table << tbody = TagNode.new('tbody')
    row_info = {}
    row_info[:total] = rows.length
    rows.each_with_index do |row,i|
      row_info[:current] = i
      tbody << tr = TagNode.new('tr', :class => cycle("","odd") )
      renderrers.each do |renderrer|
        tr << td = TagNode.new('td')
        
        if renderrer[1].class == Proc
          if table_options[:has_row_info] == true
            td << renderrer[1].call(row, row_info)
          else
            td << renderrer[1].call(row)
          end
        else
          td << renderrer[1]
        end
      end
    end
    
    return table.to_s
  end

  # Handicraft Helpers
  # menu can have submenus. You can also give 
  # menu = Menu.new({:id => "nav", :class => "blah"})
  # menu << [ "Home" , { :controller => "home" }, { :id => "home " } ]
  # if logged_in?
  #   menu << [ "A" , { :controller => "a" } ]
  #   menu << [ "B" , { :controller => "b" } ]
  #   sub_menu = Menu.new
  #     sub_menu << [ "C" , { :controller => "c", :action => "cc" } ]
  #   menu << sub_menu
  # else
  #   menu << [ "D" , { :controller => "d" } ]
  #   menu << [ "E" , { :controller => "e" ]
  # end
  # return menu

  class Menu < Array
    attr_accessor :css_id
    attr_accessor :css_class
    attr_accessor :title

    def initialize(options={})
      @css_id = options[:id]
      @css_class = options[:class]
    end

  end
  
  def render_menu(menu, options={})
    menu_id = menu.css_id ? menu.css_id : nil
    menu_class = "menu" + (menu.css_class ? " #{menu.css_class}" : "")
    
    ul = TagNode.new('ul', :id => menu_id, :class => menu_class )
    
    menu.each_with_index do |item, i|       
      item_class = "first" if i == 0
      item_class = "last" if i == (menu.length - 1)

      if item.class == Array 
        if url_for( :controller => controller.controller_name, :action => controller.action_name, :only_path => true) == item[1] || ( @highlight && @highlight.include?(item[1]) )
        item_class = "#{item_class} selected"
        end
      end
      
      ul << li = TagNode.new('li', :class => item_class)
      
      if item.class == Array
        li << link_to(item[0], item[1], item[2])
      elsif item.class == String
        li << "<p>#{item}</p>"
      elsif item.class == Menu
        li << link_to(item.title[0], h(item.title[1]), item.title[2])
        li << render_menu(item)
      end
    end
    
    return ul.to_s
  end

  # Composite pattern
  class TagNode
    include ActionView::Helpers::TagHelper
    
    def initialize(name, options = {})
      @name = name.to_s
      @attributes = options
      @children = []
    end
    
    def to_s
      value = @children.each { |c| c.to_s }.join
      content_tag(@name, value.to_s, @attributes)
    end
    
    def <<(tag_node)
      @children << tag_node
    end
  end
  
end  
end
