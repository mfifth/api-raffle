class Submission < ActiveRecord::Base
  include SendGrid

  def send_winner_emails
    mail = Mail.new
    mail.from = Email.new(email: "Kith@NYC.com")
    mail.subject = "This is the winners line."
    mail.template_id = '4f562754-fdac-4d8f-9721-8d39230cd4de'

    personalization = Personalization.new
    personalization.add_to(Email.new(email: self.email))
    personalization.add_substitution(Substitution.new(key: "-name-", value: "#{self.first_name} #{self.last_name}"))
    personalization.add_substitution(Substitution.new(key: "-email-", value: self.email))
    mail.add_personalization(personalization)

    puts mail.to_json

    sg = SendGrid::API.new(api_key: ENV['sendgrid_api_key'], host: 'https://api.sendgrid.com')
    response = sg.client.mail._('send').post(request_body: mail.to_json)

    puts response.status_code
    puts response.body
    puts response.headers
  end

  def send_loser_emails
    mail = Mail.new
    mail.from = Email.new(email: "Kith@NYC.com")
    mail.subject = "This is the losers subject line"
    mail.template_id = '4f562754-fdac-4d8f-9721-8d39230cd4de'

    personalization = Personalization.new
    personalization.add_to(Email.new(email: self.email))
    personalization.add_substitution(Substitution.new(key: "-name-", value: "#{self.first_name} #{self.last_name}"))
    personalization.add_substitution(Substitution.new(key: "-email-", value: self.email))
    mail.add_personalization(personalization)

    puts mail.to_json

    sg = SendGrid::API.new(api_key: ENV['sendgrid_api_key'], host: 'https://api.sendgrid.com')
    response = sg.client.mail._('send').post(request_body: mail.to_json)

    puts response.status_code
    puts response.body
    puts response.headers
  end
end
