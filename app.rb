require 'sinatra'
require 'sinatra/activerecord'
require 'sendgrid-ruby'
require 'jwt'
require 'json'
require_relative 'models/init'

class RaffleApp < Sinatra::Base
  post '/api/save-entry/' do
    json = {
      shoe_size: params[:shoeSize],
      location: params[:location]
    }

    submission = Submission.new(first_name: params[:firstName], last_name: params[:lastName], email: params[:email], customer_id: params[:customerId], campaign_id: params[:campaignId], meta_data_json: json.to_json)

    Pony.mail(
      to: params[:email],
      from: "Kith@NYC.com",
      subject: "Customer Welcome Email",
      html_body: erb(
        :customer_welcome_email,
        layout: false,
        locals: {
          email: params[:email],
          name: "#{params[:first_name]} #{params[:last_name]}"
        }
      )
    )

    submission.save

    token = JWT.encode({email: submission.email}, "seedCMS", "HS256")
    return token.to_json
  end
end
