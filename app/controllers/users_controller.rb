class UsersController < ApplicationController
  
  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)

  	if @user.save
      log_in @user
  		redirect_to root_path
  	else
      flash.now.alert = 'Invalid email or password'
      render 'new'
    end
  end

  protected 

  def user_params
  	params.require(:user).permit(:email, :password)
  end
end
