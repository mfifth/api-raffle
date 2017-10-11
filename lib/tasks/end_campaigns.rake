task :end_campaigns do
  namespace :end_campaigns do
    campaigns = Campaign.where('start_date >= ? AND end_date = ?', Date.yesterday, Date.today)
    if campaigns.present?
      puts "Some campaigns are ending today! Time to pick a winner and send out the prizes!"
      campaigns.each do |campaign|
        submissions = Submission.where(campaign_id: campaign.id) # <- Find all submissions that belongs to an ending campaign
        winners     = submissions.sample(campaign.max_winners) # <- Select a number of winners based on the campaign's max winners number.
        winners.each {|winner| winner.send_winner_emails}

        losers = submissions.where.not(id: winners.map(&:id)) # <- "Winners" is an normal Ruby array so we use map to get the ids and reject them from the SQL query.
        losers.each {|loser| loser.send_loser_emails} # <- Then we send the losers the email's that they deserve.
        puts "All email's have been sent!"
      end
    end
  end
end
