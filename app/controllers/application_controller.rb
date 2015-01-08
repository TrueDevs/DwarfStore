class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  protected

  def log_in(user)
  	session[:user_id] = user.id if user && user.persisted?
  end

  private

  def current_user
  	id = session[:user_id]
  	if id
  		if @current_user == nil || @current_user.id != id
  			@current_user = User.find(id)
  		end

  		@current_user
  	end
  end
end
