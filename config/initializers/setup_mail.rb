ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "gmail.com",
  :user_name            => "auster.s.chen2@gmail.com",
  :password             => "Ilovemilktea0",
  :authentication       => "plain",
  :enable_starttls_auto => true
}