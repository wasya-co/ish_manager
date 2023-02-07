require "spec_helper"

RSpec.describe IshManager::OfficeMailer, :type => :mailer do

  describe "send_campaign_email" do
    let(:campaign)      { create(:email_campaign, email_template: create(:email_template) ) }
    let(:campaign_lead) { create(:campaign_lead) }
    let(:lead)          { create(:lead) }
    let(:mail)          { IshManager::OfficeMailer.send_campaign_email( campaign.id, campaign_lead.id ) }

    it "renders the headers" do
      expect(mail.subject).to eq("Signup")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end

  end

end
