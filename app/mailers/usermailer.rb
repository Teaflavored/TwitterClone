class Usermailer < ActionMailer::Base
  default from: "auster.s.chen2@gmail.com"
  def registration_confirmation(user)
    @user = user
    mail(to: user.email, subject: "registered")
  end
  
  
  def password_reset(user)
    @user = user
    mail(to: user.email, subject: "password reset")
  end
end
