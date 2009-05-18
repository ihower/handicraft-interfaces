class Ge1ItemsController < ApplicationController

  def index
    @items = Item.find(:all, :order => 'position')
  end
  
  def sort
    
    params[:inline_edit_item].each_with_index do |item_id, new_position|
      #Item.update( item_id, :position => new_position + 1 ) # this will cause 2 queries
      Item.update_all( "position = #{new_position+1}", "id = #{item_id.to_i}" )
    end
    
    render :update do |page|
      page.replace_html 'info', "receive #{params[:inline_edit_item].join(',')}"
    end
  end
  
  def edit
    @item = Item.find(params[:id])
    
    render :update do |page|
      page.replace_html dom_id(@item, :inline_edit), :partial => 'edit', :locals => { :item => @item }
    end
  end
  
  
  def update
    @item = Item.find(params[:id])
    @item.update_attributes(params[:item])
    
    render :update do |page|
      @item.reload unless @item.valid?
      page.replace_html dom_id(@item, :inline_edit), :partial => 'show', :locals => { :item => @item }
      page.visual_effect :highlight, dom_id(@item, :inline_edit)
    end
    
  end
  
  def destroy
    @item = Item.find(params[:id])
    @item.destroy
    
    render :update do |page|
      page.replace_html dom_id(@item, :inline_edit)
      page.visual_effect :fade, dom_id(@item)
    end
  end
  
end
