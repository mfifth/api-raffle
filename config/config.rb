require 'sinatra/base'
require 'pony'

class Application < Sinatra::Base
  configure do |config|
    Pony.options = {
      :via => :smtp,
      :via_options => {
        :address => 'smtp.sendgrid.net',
        :port => '587',
        :domain => 'https://raffle-api-app.herokuapp.com/',
        :user_name => 'app78314436@heroku.com',
        :password => 'ib7k5quw4122',
        :authentication => :plain,
        :enable_starttls_auto => true
      }
    }

    config.middleware.insert_before 0, "Rack::Cors" do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :options]
      end
    end
  end
end
