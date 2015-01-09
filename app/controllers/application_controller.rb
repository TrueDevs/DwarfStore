class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  protected

  def sign_in(user)
  	session[:token] = user.token! if user && user.persisted?
  end

  def sign_out
    session[:token] = nil
  end

  private

  def current_user
    token = session[:token]
  	if token
  		if @current_user.nil? || @current_user.auth_token != token
        @current_user = User.find_by(auth_token: token) 
      end
      @current_user
    end
  end
end
