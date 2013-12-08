class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :authenticate_user
  
  helper_method :current_user, :logged_in?

  protected
  
  def authenticate_user
    if !logged_in?
      flash.alert = "Unauthorized Access"
      redirect_to root_url
    end
  end

  private
  
  def current_user
    @current_user ||= Admin.find(session[:admin_id]) if session[:admin_id]
  end
  
  def logged_in?
    !current_user.nil?
  end
  
end
