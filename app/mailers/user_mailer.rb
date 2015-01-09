class UserMailer < ActionMailer::Base
  default from: "true.devs.test@gmail.com"

  def welcome_email(user)
  	@user = user
  	mail(to: @user.email, subject: 'Welcome to DwarfStore')
  end

  def reset_password_email(user)
  	@user = user
  	mail(to: @user.email, subject: 'Reset password for DwarfStore account')
  end

end
