
class IshManager::OfficeMailer < IshManager::ApplicationMailer
  default from: 'WasyaCo Consulting <no-reply@wasya.co>'

  def send_campaign_email campaign_id, c_lead_id
    @ctx = @campaign = ::Ish::EmailContext.find campaign_id
    @lead = EmailCampaignLead.find c_lead_id

    if @lead.sent_at
      raise "This campaign_lead #{@lead.id} has already been sent."
    end

    actl = ActionController::Base.new
    actl.instance_variable_set( :@ctx, @ctx )

    @pixel_tracking = {
      'v'   => 1,
      'tid' => 'UA-53077236-2',
      'cid' => @lead.cid,
      'uid' => @lead.uid,
      't'   => 'event',
      'ec'  => 'email',
      'ea'  => 'open',
      'cn'  => @campaign.slug,
      'ci'  => @campaign.slug,
      'cm'  => 'email',
      'utm_source'   => @campaign.slug,
      'utm_medium'   => 'email',
      'utm_campaign' => @campaign.slug,
    }.map { |k, v| "#{k}=#{v}" }.join("&")
    actl.instance_variable_set( :@pixel_tracking, @pixel_tracking )

    @click_tracking = {
      'cid' => @lead.cid,
      'uid' => @lead.uid,
      't'   => 'event',
      'ec'  => 'email',
      'ea'  => 'clk-ctct', # clicked contact us
      'utm_source'   => @campaign.slug,
      'utm_medium'   => 'email',
      'utm_campaign' => @campaign.slug,
    }.map { |k, v| "#{k}=#{v}" }.join("&")
    actl.instance_variable_set( :@click_tracking, @click_tracking )

    actl.instance_variable_set( :@lead, @lead )

    template = "render/_#{@ctx.email_template.slug}"
    rendered_str = actl.render_to_string("ish_manager/email_templates/_#{@ctx.email_template.slug}")
    @lead.update( rendered_str: rendered_str, sent_at: Time.now )

    mail( from: @ctx.from_email,
      to: @lead.email,
      subject: @ctx.subject,
      template_name: template )
  end

  ## 2023-04-02 _vp_ Continue.
  def send_context_email ctx_id
    @ctx = Ctx.find ctx_id
    ac   = ActionController::Base.new
    ac.instance_variable_set( :@ctx, @ctx )

    rendered_str = ac.render_to_string("ish_manager/email_templates/_#{@ctx.tmpl.layout}")
    @ctx.update({
      rendered_str: rendered_str,
      sent_at: Time.now.to_s,
    })

    mail( from: @ctx.from_email,
          to: @ctx.to_email,
          subject: @ctx.subject,
          template_name: "render/_#{@ctx.tmpl.layout}" )
  end

end
