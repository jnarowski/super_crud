module SuperCrud
  module Controller 
    
    # def self.included(base)
    #   base.extend(ClassMethods)
    # end
    #   
    # module ClassMethods
    #   def acts_as_super_crud
    #     include SuperCrud::Controller
    #   end
    # end
    
    #----------------------------------------------------------------
    # controller functionality
    # -- you can override or extend if you want
    #----------------------------------------------------------------

    def display_list    
      load_params
      load_objects
      update_list
    end

    def index
      load_params
      load_objects
    end

    def edit
      respond_to do |format|
        format.html # edit.html
      end
    end

    def show
      load_object
    end

    #----------------------------------------------------------------
    # CRUD helper methods
    #----------------------------------------------------------------

    def _create(object, path = nil)
      respond_to do |format|
        if object.save
          load_objects
          flash[:notice] = "#{@_name} was successfully created."
          format.html { redirect_to(set_path(object, path)) }
        else
          format.html { render :action => "new" }
        end
      end
    end

    def _update(object, path = nil)
      respond_to do |format|
        if object.update_attributes(@_attributes)
          flash[:notice] = "#{@_name} was successfully updated."
          format.html { redirect_to(set_path(object, path)) }
        else
          format.html { render :action => "edit" }
        end
      end
    end

    def _destroy(name, object, object_name)
      object.destroy
      respond_to do |format|
        format.js { simple_destroy(name, object, :message => "#{object_name} has been removed.") }
      end
    end

    #----------------------------------------------------------------
    # helper functions
    #----------------------------------------------------------------

    # used to set the path in the #_update and #_create methods
    def set_path(object, path)
      path.blank? ? "#{@_path}/#{object.id}" : path
    end

    # if the user has searched, add the search filter parameter
    # this will pop the box in the top of the table listing
    def add_search_if_present(collections)
      if params[:search]
        @filter_text = "Search for '#{params[:search]}'"
        collections.search(params[:search])
      else
        collections
      end
    end

    # This is used to add extra parameters to the column_heading and pagination filtering
    #   in the controller if you wanted to add the params[:search] to the filters
    #   EG: add_extra_param(:search)
    #
    def add_filter_param(name)
      @extra_params[name] = params[name] unless params[name].blank?
    end

    #----------------------------------------------------------------
    # searching and sorting helpers
    #----------------------------------------------------------------

    def get_order(ordering, exact = false)
      if ordering
        order_array = ordering.split("_")
        direction = (order_array[0] == 'ascend') ? 'ASC' : 'DESC'
        column = ''
        order_array.each_with_index {|a, index| column += "#{a}_" if index > 1}
        column = column[0..-2]
        "#{column} #{direction}"
      end
    end

    #----------------------------------------------------------------
    # shared rjs methods
    #----------------------------------------------------------------

    def update_list(options = {})      
      options[:sidebar] = 'side_menu'    
      render :update do |page|
        page.replace_html 'list', :partial => 'list'
        page.replace_html 'side-menu', :partial => options[:sidebar] if options[:reload_sidebar]    
        page.replace_html options[:reload_partial], :partial => options[:reload_partial] if options[:reload_partial] 
        # show the advanced filter text
        unless @filter_text.blank?
          page.replace_html 'filter', filter_results 
          page.show "filter"
        end
      end
    end

    def simple_destroy(id, object, options = {})
      dom_id = options[:id] ? options[:id] : "#{id}-#{object.id}"
      render :update do |page|
        page.remove dom_id
      end
    end

    #----------------------------------------------------------------
    # private functionaltiy
    #----------------------------------------------------------------

    private 

      # this loads params for the index page 
      # sets defaults for column sorting, searching etc
      def load_params
        super
        @extra_params = {}
        @ordering ||= 'descend_by_created_at'
        add_filter_param(:search)
      end

      # sets page default options, selected tab states ETC
      def initialize_page
        super
        action = action_name == 'index' ? "#{@_name}s" : "#{action_name.capitalize} #{@_name}"
        @page_title = action
        @render_options[:selected_tab] = @_selected_tab
      end
    end
  
end