module ApplicationHelper

   def activate_link_text(activatable)
      activatable.active? ? 'Pause' : 'Start'
   end
   
   

   def link_to_remove_fields(name, f)
      f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
   end

   def is_active?(page_name)
      "active" if params[:action] == page_name
   end


   def title
      base_title = "GroupHug"
      if @title.nil?
         @title = base_title
      else
         "#{base_title} | #{@title}"
      end
   end

   private

   def authenticate
      deny_access unless signed_in?
   end

   def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
   end

   def admin_user
      redirect_to(root_path) unless current_user.admin?
   end

   def is_admin?
      current_user.admin?
   end

end


