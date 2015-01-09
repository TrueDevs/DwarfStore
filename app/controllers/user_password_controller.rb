class UserPasswordController < ApplicationController
  def new
  	@new_reset = true
  end

  def create
  	@new_reset = false
    user = User.find_by(email: params[:email])
    
    if user
      user.reset_token = user.id.to_s + SecureRandom.hex.to_s
      user.reset_time = Time.now

      user.save
      UserMailer.reset_password_email(user).deliver
    end
  	
    render 'new'
  end

  def edit
    @user = User.find_by(reset_token: params[:id])
  end

  def update
    @user = User.find_by(reset_token: params[:id])
    redirect_to root_path unless @user

    password = params[:password]
    if password.size > 0 && @user.update(password: password)
      @user.reset_token = nil
      @user.save!
      
      redirect_to sign_in_path
    else
      render 'edit'
    end
  end
end
