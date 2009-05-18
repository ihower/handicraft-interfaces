class PeopleController < ApplicationController
  
  def index
    @people = Person.find(:all)
    @person = Person.new
  end

  def show
    @person = Person.find(params[:id])

    respond_to do |format|
      format.html
      format.js { 
        render :update do |page|
          page << "alert('you click #{@person.name}')"
        end
      }
      format.json { render_to_json }
    end
  end

  def edit
    @person = Person.find(params[:id])
    
    respond_to do |format|
      format.html { render :layout => false }
    end
  end

  def create
    @person = Person.new(params[:person])
    
    respond_to do |format|
      if @person.save
        format.html { redirect_to person_url(@person) }
        format.js {
          render :update do |page|
            page.insert_html :bottom, "people", :partial => 'person', :locals => { :person => @person }
            page.visual_effect :highlight, dom_id(@person)
            page << "$('#new-form').resetForm();"
          end
        }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @person = Person.find(params[:id])

    respond_to do |format|
      if @person.update_attributes(params[:person])
        format.html { redirect_to person_url(@person) }
        format.js {
          render :update do |page|
            page.replace dom_id(@person), :partial => 'person', :locals => { :person => @person }
            page.visual_effect :highlight, dom_id(@person)
            page.replace_html 'content',''
          end
        }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @person = Person.find(params[:id])
    @person.destroy

    respond_to do |format|
      format.html { redirect_to(people_url) }
      format.js { 
        render :update do |page|
          page.visual_effect :fade, dom_id(@person) 
        end
      }
      format.json {
        render :json => { :html_id => dom_id(@person), :message => 'Delete done' }.to_json
      }
    end
  end
  
  protected
  
  def render_to_json( options = {} )
    options[:template] = "#{default_template_name}.html.erb" if options.empty?
    
    action_string = render_to_string(:action => options[:action], :layout => false) if options[:action]
    template_string = render_to_string(:template => options[:template], :layout => false) if options[:template]
    
    render :json => template_string.to_json
  end
  
end
