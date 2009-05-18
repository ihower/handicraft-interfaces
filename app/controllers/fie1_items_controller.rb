class Fie1ItemsController < ApplicationController

  def index
    @items = Item.find(:all)
  end
  
  def edit
    @item = Item.find(params[:id])
    
    respond_to do |format|
      format.html { render :partial => 'edit', :locals => { :item => @item } }
      format.js {
        render :update do |page|
          page.replace_html dom_id(@item, :inline_edit), :partial => 'edit', :locals => { :item => @item }
        end
      }
    end

  end
  
  
  def update
    @item = Item.find(params[:id])
    @item.update_attributes(params[:item])
    
    respond_to do |format|
      format.html { redirect_to fie1_items_url }
      format.js {
        render :update do |page|
          @item.reload unless @item.valid?
          page.replace_html dom_id(@item, :inline_edit), :partial => 'show', :locals => { :item => @item }
          page.visual_effect :highlight, dom_id(@item, :inline_edit)
        end
      }
    end
    
  end
  
end
