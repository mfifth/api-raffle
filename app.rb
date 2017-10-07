require 'sinatra'
require 'sinatra/activerecord'
require 'sendgrid-ruby'
require 'jwt'
require 'json'
require_relative 'models/init'

class RaffleApp < Sinatra::Base
  include SendGrid
  post '/api/save-entry/' do
    json = {
      shoe_size: params[:shoeSize],
      location: params[:location]
    }

    submission = Submission.new(first_name: params[:firstName], last_name: params[:lastName], email: params[:email], customer_id: params[:customerId], campaign_id: params[:campaignId], meta_data_json: json.to_json)

    mail = Mail.new
    mail.from = Email.new(email: "Kith@NYC.com")
    mail.template_id = '8dee8601-c356-49fc-811a-e2ccaa9ad818'

    personalization = Personalization.new
    personalization.add_to(Email.new(email: params[:email]))
    personalization.add_substitution(Substitution.new(key: '%name%', value: "#{submission.first_name} #{submission.last_name}"))
    personalization.add_substitution(Substitution.new(key: '%email%', value: "#{submission.email}"))
    mail.add_personalization(personalization)

    puts mail.to_json

    sg = SendGrid::API.new(api_key: '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', host: 'https://api.sendgrid.com')
    response = sg.client.mail._('send').post(request_body: mail.to_json)

    puts response.status_code
    puts response.body
    puts response.headers

    submission.save

    token = JWT.encode({email: submission.email}, "seedCMS", "HS256")
    puts token
  end
end
