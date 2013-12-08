class SessionsController < ApplicationController  
  skip_before_filter :authenticate_user
  
  def new
    if logged_in?
      redirect_to home_index_url
    end
  end
  
  def create
    admin = Admin.authenticate(params[:login_code], params[:password])
    if admin
      reset_session
      session[:admin_id] = admin.id
      redirect_to home_index_url, :notice => "Logged in successfully"
    else
      flash.alert = "Invalid email or password"
      redirect_to root_url
    end
  end
  
  def destroy
    session[:admin_id] = nil
    redirect_to root_url, :notice => "Logged out successfuly"
  end
end
