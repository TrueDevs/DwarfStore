class UsersController < ApplicationController
  before_action :correct_user, only: [:index, :update]

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)
    created = @user.save

  	if created
      UserMailer.welcome_email(@user).deliver
      sign_in @user
    end

    respond_to do |format|
      format.html do
        if created
          redirect_to root_path
        else
          render 'new'
        end
      end

      format.json do
        if created
          render json: @user, status: 401
        else
          render json: @user.errors, status: 422
        end
      end

    end

  end

  def index
    @users = User.all

    respond_to do |format| 
      format.json { render json: @users, status: 200 }
      format.html {}
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if params[:user][:banned] #change banned status
      ban_action(@user, params[:user][:banned]) 
      return
    end

    if params[:user][:email] #change email
      change_email(@user, params[:user][:password], params[:user][:email])
      return
    end
  end

  protected 

  def ban_action(user, banned)
    banned = to_boolean(banned) if banned.instance_of? String

    if banned
      @user.ban_user current_user
    else
      @user.clear_ban current_user
    end

    respond_to do |format|
      format.html {redirect_to root_path}
      format.js {}
      format.json { render json: @user }
    end
  end

  def change_email(user, password, new_email)
    unless user.auth(password)
      render json: '{ error: "Access denied!" }', status: 403 
      return
    end

    if user.update(email: new_email) 
      render json: user, status: 200
    else
      render json: user.errors.full_messages, status: 406
    end
  end

  def user_params
  	params.require(:user).permit(:email, :password)
  end

  def correct_user(user=nil)
    access_denied = current_user.nil? #guest 
    access_denied ||= !current_user.super_user? # user that are not super user
    access_denied ||= !user.nil? && user.super_user? && (user != current_user) # super user has no access to other superuses! 
    
    return unless access_denied

    respond_to do |format|
      format.html { redirect_to root_path}
      format.json { render json: '{ error: "Access denied!" }', status: 403 }
    end
  end
end
