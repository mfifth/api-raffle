require 'sinatra'
require 'sinatra/activerecord'
require 'action_mailer'
require 'jwt'
require 'json'
require_relative 'models/init'
require_relative 'mailer/init'

class RaffleApp < Sinatra::Base
  post '/api/save-entry/' do
    json = {
      shoe_size: params[:shoeSize],
      location: params[:location]
    }

    submission = Submission.new(first_name: params[:firstName], last_name: params[:lastName], email: params[:email], customer_id: params[:customerId], campaign_id: params[:campaignId], meta_data_json: json.to_json)

    Mailer.customer_welcome_email(submission).deliver_now
    submission.save

    token = JWT.encode({email: submission.email}, "seedCMS", "HS256")
    puts token
  end
end
