class AdminScaffoldGenerator < Rails::Generator::Base
  def manifest
    record do |m|

      # Create the directories
      m.directory 'app/controllers/admin'
      m.directory 'app/helpers/admin'
      m.directory 'app/views/admin'

      # Controller    
      m.file "admin_controller.rb", "app/controllers/admin/admin_controller.rb"
      
      # Helper
      m.file "admin_helper.rb", "app/helpers/admin_helper.rb" 
      
      # Layout
      m.file "admin.html.erb", "app/views/layout/admin.html.erb"
            
      # CSS, Javascript and Images
      m.file "admin.js", "public/javascripts/admin.js"
      m.file "admin.css", "public/javascripts/admin.css"

      #m.readme "INSTALL"
    end
  end

  def file_name
    "create_users"
  end

end
