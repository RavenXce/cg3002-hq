module ApplicationHelper  
  def login_page?
    current_page?(:controller => 'sessions', :action => 'new') || current_page?(:default)
  end  
end
