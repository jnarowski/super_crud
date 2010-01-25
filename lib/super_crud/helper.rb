module SuperCrud
  module Helper
    #----------------------------------------------------------------
    # framework stuff
    #----------------------------------------------------------------

    def filter_results
      out = ""
      out += "<div id=\"filter-results-count\" class=\"float-right\">#{@filter_count} found #{link_to(icon('cross'), {:controller => controller_name})}</div>" if @filter_count
      out += "<div id=\"filter-results\">#{@filter_text}</div>#{}" if @filter_text
      out
    end

  	def super_header(name, &block)
  	  heading = "<h1>#{name}</h1>"
  	  concat("<div id='sub-header'>#{capture(&block)}#{heading}#{float_clear}</div>")
  	end

  	def super_table(&block)
  	  table_start = '<div id="filter" class="rounded" style="display: none;"></div>
        <table class="stripped-list list" cellspacing="0" width="750px">'
  	  concat("#{table_start}#{capture(&block)}</table>")    
  	end

  	def super_row(name, object, iterator = nil, &block)
  	  line = (iterator ? iterator % 2 : 0)
  	  concat("<tr id='#{name}-#{object.id}' class='line-#{line} padded-td'>#{capture(&block)}</tr>")    
  	end

  	def super_paginate(collection)
  	  "<div id='table-footer'>#{super_custom_remote_paginate(collection)}</div>"
  	end

  	# table header
  	def table_header(width, name, column, options = {})
  	  filler = options[:plain_text].blank? ? super_column_heading(name, column) : name
      "<th width='#{width}' class='#{options[:class]}'>#{filler}</th>"
  	end

  	def super_button(name, link, options = {})
  	  div_style = options.delete(:div_style) 
  	  "<div class='button' style='#{div_style}'>#{link_to(name, link, options)}</div>"
  	end

    def super_menu_item(name, link, selected = nil, options = {})
      options[:class] = 'selected' if selected == @render_options[:selected_tab] && !@render_options[:selected_tab].blank?
      "<li>#{link_to(name, link, options)}</li>"
    end

    #----------------------------------------------------------------
    # general helpers
    #----------------------------------------------------------------

    def set_admin_url(object, path)
      object.new_record? ? "/admin/#{path}/" : "/admin/#{path}/#{object.id}"
    end

    def super_icon(type, options = {})
      width = 16
      alt = nil
      file_name = "#{type}.png"
      "<img src=\"/images/icons/#{file_name}\" alt=\"#{alt ? alt : type}\" #{"title=\"#{alt}\"" if !alt.blank?} style=\"width: #{width}px;\" />"
    end

    #----------------------------------------------------------------
    # show helpers
    #----------------------------------------------------------------

    def super_show_item(name, value)
      value = value.blank? ? '<i>null</i>' : value
      "<p>
        <label class='strong'>#{name}</label>
        #{value}      
      </p>"
    end

    #----------------------------------------------------------------
    # table sorting and filtering helpers
    #----------------------------------------------------------------

    def super_column_heading(display_name, attribute, controller = controller_name)
      options = {
        :controller => controller,
        :action => 'display_list',
        :ordering => ordering(attribute), 
        :attribute => attribute.to_s 
      }.merge!(@extra_params)  
      link_to("#{display_name} #{super_triangle(attribute)}", options, :class => 'column-header')
    end  

    def super_custom_remote_paginate(collection, options = {})
      options[:ordering] ||= @ordering
      options[:attribute] ||= @attribute
      options[:controller] ||= controller_name
      options[:action] ||= 'display_list'
      options[:method] ||= 'post'
      options.merge!(@extra_params)
      "<div class='pagination'>#{will_paginate(collection, :params => options, :remote => {})}</div>#{float_clear}"
    end


    def super_triangle(attribute)
      return "&#9650;" if @ordering == "ascend_by_#{attribute}" 
      return "&#9660;" if @ordering == "descend_by_#{attribute}" 
    end

    def ordering(attribute)
      if @ordering == "ascend_by_#{attribute}" then
        "descend_by_#{attribute}"
      else
        "ascend_by_#{attribute}"
      end
    end
  end
  
end