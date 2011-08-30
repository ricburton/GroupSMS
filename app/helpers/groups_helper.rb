module GroupsHelper
  def add_user_link(name)
    link_to_function name do |page|
      page.insert_html :bottom, :users, :partial => 'user', :object => Group.new
    end
  end
end
