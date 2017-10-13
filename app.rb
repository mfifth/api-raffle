require 'sinatra'
require 'sinatra/activerecord'
require 'dotenv/load'
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

    puts submission.inspect

    mail = Mail.new
    mail.from = Email.new(email: "Kith@NYC.com")
    mail.subject = "This is a subject line."
    mail.template_id = '4f562754-fdac-4d8f-9721-8d39230cd4de'

    personalization = Personalization.new
    personalization.add_to(Email.new(email: params[:email]))
    personalization.add_substitution(Substitution.new(key: "-name-", value: "#{submission.first_name} #{submission.last_name}"))
    personalization.add_substitution(Substitution.new(key: "-email-", value: submission.email))
    mail.add_personalization(personalization)

    puts mail.to_json

    sg = SendGrid::API.new(api_key: ENV['sendgrid_api_key'], host: 'https://api.sendgrid.com')
    response = sg.client.mail._('send').post(request_body: mail.to_json)

    puts response.status_code
    puts response.body
    puts response.headers

    submission.save
    return 200
  end

  post '/api/save-campaign/' do
    campaign = Campaign.create(campaign_name: params[:campaignName], start_date: params[:startDate].to_date, end_date: params[:endDate].to_date, max_entries: params[:maxEntries], max_winners: params[:winnerCount], limit_per_ip: params[:limitByIp], limit_per_email: params[:oneEntryPerEmail], agree_to_terms: params[:agreeToTerms], campaign_products: params[:campaignProducts], campaign_collections: params[:campaignCollection])

    puts "Campaign #{campaign.campaign_name} was saved successfully."
    return 200
  end

  get '/api/campaigns.json' do
    content_type :json
    Campaign.all.to_json
  end
end
