class UsersController < ApplicationController
  
  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)

  	if @user.save
      UserMailer.welcome_email(@user).deliver
      
      sign_in @user
  		redirect_to root_path
  	else
      flash.now.alert = 'Invalid email or password'
      render 'new'
    end
  end

  def index
    if current_user.nil? || !current_user.super_user?
      redirect_to root_path
    else
      @users = User.all
    end
  end

  protected 

  def user_params
  	params.require(:user).permit(:email, :password)
  end
end
