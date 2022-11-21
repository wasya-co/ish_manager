
##
## EmailContext is mongoid
##
class IshManager::EmailCampaignJob < ApplicationJob
  include Sidekiq::Worker
  Sidekiq_options queue: "default"

  def perform campaign_id
    @ctx = @campaign = ::Ish::EmailContext.find campaign_id
    print "Sending #{@campaign.slug}:"

    if @ctx.email_template.type != 'partial'
      raise "only `partial` template type is supported for campaigns."
    end

    if @ctx.sent_at
      raise 'This campaign has already been sent!'
    end

    @ctx.campaign_leads.each do |campaign_lead|
      IshManager::OfficeMailer.send_campaign_email( campaign_id, campaign_lead.id ).deliver_later
      print '.'
    end

    @campaign.update_attributes({ sent_at: Time.now })

    puts 'ok'
  end

end
