class Ge1ItemsController < ApplicationController

  def index
    @items = Item.find(:all, :order => 'position')
  end
  
  def sort
    @new_position = params[:inline_edit_item]
    
    @invert_new_position=[]
    @new_position.each_with_index do |item_id, new_position|
      @invert_new_position[item_id.to_i - 1] = new_position + 1
    end
    
    @items = Item.find(:all, :order => 'id')
    
    @items.each_with_index do |item, i|
      item.update_attribute( :position, @invert_new_position[i] )
    end
    
    render :update do |page|
      page.replace_html 'info', "affect #{@items.size} items, receive #{@new_position.join(',')} and #{@invert_new_position.join(',') }"
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
