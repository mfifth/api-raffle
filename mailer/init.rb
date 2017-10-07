configure do
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.raise_delivery_errors = true
  ActionMailer::Base.smtp_settings = {
    :address => "smtp.sendgrid.net",
    :port => '25',
    :authentication => :plain,
    :user_name => 'app78314436@heroku.com',
    :password => 'ib7k5quw4122',
    :domain => 'raffle-api-app.herokuapp.com'
  }
  ActionMailer::Base.view_paths = File.join(Sinatra::Application.root, 'views')
  set :root,    File.dirname(__FILE__)
  set :views,   File.join(Sinatra::Application.root, 'views')
end

class Mailer < ActionMailer::Base
  def customer_welcome_email(submission)
    @submission = submission
    mail(to: submission.email, from: "Kith@NYC.com", subject: "Custom Email Message")
  end
end
