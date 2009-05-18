# Extract from jRails http://ennerchi.com/projects/jrails
module ActionView
  module Helpers
     
    module JavaScriptHelper
      
      # This function can be used to render rjs inline
      #
      # <%= javascript_function do |page|
      #   page.replace_html :list, :partial => 'list', :object => @list
      # end %>
      #
      def javascript_function(*args, &block)
        html_options = args.extract_options!
        function = args[0] || ''

        html_options.symbolize_keys!
        function = update_page(&block) if block_given?
        javascript_tag(function)
      end
      
      def jquery_id(id)
        id.to_s.count('#.*,>+~:[/ ') == 0 ? "##{id}" : id
      end
          
      def jquery_ids(ids)
        Array(ids).map{|id| jquery_id(id)}.join(',')
      end

    end
         
    module PrototypeHelper
      
      unless const_defined? :JQUERY_VAR
        JQUERY_VAR = '$'
      end
            
      class JavaScriptGenerator
        module GeneratorMethods
          
          def insert_html(position, id, *options_for_render)
            insertion = position.to_s.downcase
            insertion = 'append' if insertion == 'bottom'
            insertion = 'prepend' if insertion == 'top'
            call "#{JQUERY_VAR}(\"#{jquery_id(id)}\").#{insertion}", render(*options_for_render)
          end
          
          def replace_html(id, *options_for_render)
            insert_html(:html, id, *options_for_render)
          end
          
          def replace(id, *options_for_render)
            call "#{JQUERY_VAR}(\"#{jquery_id(id)}\").replaceWith", render(*options_for_render)
          end
          
          def remove(*ids)
            call "#{JQUERY_VAR}(\"#{jquery_ids(ids)}\").remove"
          end
          
          def show(*ids)
            call "#{JQUERY_VAR}(\"#{jquery_ids(ids)}\").show"
          end
          
          def hide(*ids)
            call "#{JQUERY_VAR}(\"#{jquery_ids(ids)}\").hide"
          end

          def toggle(*ids)
            call "#{JQUERY_VAR}(\"#{jquery_ids(ids)}\").toggle"
          end
          
          def jquery_id(id)
            id.to_s.count('#.*,>+~:[/ ') == 0 ? "##{id}" : id
          end
          
          def jquery_ids(ids)
            Array(ids).map{|id| jquery_id(id)}.join(',')
          end
          
        end
      end
      
    end
    
    class JavaScriptElementProxy < JavaScriptProxy #:nodoc:
      
      unless const_defined? :JQUERY_VAR
        JQUERY_VAR = ActionView::Helpers::PrototypeHelper::JQUERY_VAR
      end
      
      def initialize(generator, id)
        id = id.to_s.count('#.*,>+~:[/ ') == 0 ? "##{id}" : id
        @id = id
        super(generator, "#{JQUERY_VAR}(\"#{id}\")")
      end
      
      def replace_html(*options_for_render)
        call 'html', @generator.send(:render, *options_for_render)
      end

      def replace(*options_for_render)
        call 'replaceWith', @generator.send(:render, *options_for_render)
      end
      
      def reload(options_for_replace={})
        replace(options_for_replace.merge({ :partial => @id.to_s.sub(/^#/,'') }))
      end
      
      def value()
        call 'val()'
      end

      def value=(value)
        call 'val', value
      end
      
    end
    
    class JavaScriptElementCollectionProxy < JavaScriptCollectionProxy #:nodoc:\
      
      unless const_defined? :JQUERY_VAR
        JQUERY_VAR = ActionView::Helpers::PrototypeHelper::JQUERY_VAR
      end
      
      def initialize(generator, pattern)
        super(generator, "#{JQUERY_VAR}(#{pattern.to_json})")
      end
    end
    
    module ScriptaculousHelper
      
      unless const_defined? :JQUERY_VAR
        JQUERY_VAR = ActionView::Helpers::PrototypeHelper::JQUERY_VAR
      end
      
      unless const_defined? :SCRIPTACULOUS_EFFECTS
        SCRIPTACULOUS_EFFECTS = {
          :appear => {:method => 'fadeIn'},
          :blind_down => {:method => 'blind', :mode => 'show', :options => {:direction => 'vertical'}},
          :blind_up => {:method => 'blind', :mode => 'hide', :options => {:direction => 'vertical'}},
          :blind_right => {:method => 'blind', :mode => 'show', :options => {:direction => 'horizontal'}},
          :blind_left => {:method => 'blind', :mode => 'hide', :options => {:direction => 'horizontal'}},
          :bounce_in => {:method => 'bounce', :mode => 'show', :options => {:direction => 'up'}},
          :bounce_out => {:method => 'bounce', :mode => 'hide', :options => {:direction => 'up'}},
          :drop_in => {:method => 'drop', :mode => 'show', :options => {:direction => 'up'}},
          :drop_out => {:method => 'drop', :mode => 'hide', :options => {:direction => 'down'}},
          :fade => {:method => 'fadeOut'},
          :fold_in => {:method => 'fold', :mode => 'hide'},
          :fold_out => {:method => 'fold', :mode => 'show'},
          :grow => {:method => 'scale', :mode => 'show'},
          :shrink => {:method => 'scale', :mode => 'hide'},
          :slide_down => {:method => 'slide', :mode => 'show', :options => {:direction => 'up'}},
          :slide_up => {:method => 'slide', :mode => 'hide', :options => {:direction => 'up'}},
          :slide_right => {:method => 'slide', :mode => 'show', :options => {:direction => 'left'}},
          :slide_left => {:method => 'slide', :mode => 'hide', :options => {:direction => 'left'}},
          :squish => {:method => 'scale', :mode => 'hide', :options => {:origin => "['top','left']"}},
          :switch_on => {:method => 'clip', :mode => 'show', :options => {:direction => 'vertical'}},
          :switch_off => {:method => 'clip', :mode => 'hide', :options => {:direction => 'vertical'}},
          :toggle_appear => {:method => 'fadeToggle'},
          :toggle_slide => {:method => 'slide', :mode => 'toggle', :options => {:direction => 'up'}},
          :toggle_blind => {:method => 'blind', :mode => 'toggle', :options => {:direction => 'vertical'}},
        }
      end
      
      def visual_effect(name, element_id = false, js_options = {})
        element = element_id ? element_id : "this"
        
        if SCRIPTACULOUS_EFFECTS.has_key? name.to_sym
          effect = SCRIPTACULOUS_EFFECTS[name.to_sym]
          name = effect[:method]
          mode = effect[:mode]
          js_options = js_options.merge(effect[:options]) if effect[:options]
        end
        
        [:color, :direction].each do |option|
          js_options[option] = "'#{js_options[option]}'" if js_options[option]
        end
        
        if js_options.has_key? :duration
          speed = js_options.delete :duration
          speed = (speed * 1000).to_i unless speed.nil?
        else
          speed = js_options.delete :speed
        end
        
        if ['fadeIn','fadeOut','fadeToggle'].include?(name)
          javascript = "#{JQUERY_VAR}('#{jquery_id(element_id)}').#{name}("
          javascript << "#{speed}" unless speed.nil?
          javascript << ");"
        else
          javascript = "#{JQUERY_VAR}('#{jquery_id(element_id)}').#{mode || 'effect'}('#{name}'"
          javascript << ",#{options_for_javascript(js_options)}" unless speed.nil? && js_options.empty?
          javascript << ",#{speed}" unless speed.nil?
          javascript << ");"
        end
        
      end
      
    end
    
  end
end
