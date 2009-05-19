class HandicraftController < ApplicationController
  
  def index
    @items = Item.find(:all)
  end
  
end
