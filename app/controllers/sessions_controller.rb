class SessionsController < ApplicationController
  def new
  end

  def create
  	user = User.auth(params[:email], params[:password])
  	if user
      sign_in user
  		redirect_to root_path
  	else
  		render 'new'
  	end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
