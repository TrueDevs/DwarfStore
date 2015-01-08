class SessionsController < ApplicationController
  def new
  end

  def create
  	user = User.auth(params[:email], params[:password])
  	if log_in user
  		redirect_to root_path
  	else
  		render 'new'
  	end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end
