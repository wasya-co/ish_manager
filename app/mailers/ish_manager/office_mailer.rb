
class IshManager::OfficeMailer < IshManager::ApplicationMailer

  def send_campaign campaign_id
    @ctx = ::Ish::EmailContext.find campaign_id
    actl = ActionController::Base.new
    actl.instance_variable_set( :@ctx, @ctx )

    if @ctx.email_template.type != 'partial'
      raise "only `partial` template type is supported for campaigns."
    end

    puts! @ctx.leads, '@ctx.leads'

    @ctx.leads.each do |clead| # a campaign lead
      @lead = clead

      @pixel_tracking = {
        'v'   => 1,
        'tid' => 'UA-53077236-2',
        'cid' => @lead[:cid],
        't'   => 'event',
        'ec'  => 'email',
        'ea'  => 'open',
        'utm_source'   => 'eror1',
        'utm_medium'   => 'email',
        'utm_campaign' => 'eror1',
      }.map { |k, v| "#{k}=#{v}" }.join("&")
      actl.instance_variable_set( :@pixel_tracking, @pixel_tracking )

      @click_tracking = {
        'cid' => @lead[:cid],
        't'   => 'event',
        'ec'  => 'email',
        'ea'  => 'clk-ctct', # clicked contact us
        'utm_source'   => 'eror1',
        'utm_medium'   => 'email',
        'utm_campaign' => 'eror1',
      }.map { |k, v| "#{k}=#{v}" }.join("&")
      actl.instance_variable_set( :@click_tracking, @click_tracking )


      actl.instance_variable_set( :@lead, @lead )

      template = "render/_#{@ctx.email_template.slug}"
      # rendered_str = actl.render_to_string("ish_manager/email_templates/_#{@ctx.email_template.slug}")
      # @lead.update( rendered_str: rendered_str, sent_at: Time.now )

      mail( from: @ctx.from_email,
        to: @lead.email,
        bcc: 'piousbox@gmail.com',
        subject: @ctx.subject,
        template_name: template )
    end
  end

  def send_context_email ctx_id
    @email_ctx = ::Ish::EmailContext.find ctx_id
    ac = ActionController::Base.new
    ac.instance_variable_set( :@email_ctx, @email_ctx )

    case @email_ctx.email_template.type
    when 'partial'
      template = "render/_#{@email_ctx.email_template.slug}"
      rendered_str = ac.render_to_string("ish_manager/email_templates/_#{@email_ctx.email_template.slug}")
    when 'plain'
      @body = @email_ctx.email_template.body
      @body.gsub!('{name}', @email_ctx.name)
      template = "render/plain"
      rendered_str = ac.render_to_string("ish_manager/email_templates/plain")
    end

    @email_ctx.update( rendered_str: rendered_str, sent_at: Time.now )

    mail( from: @email_ctx.from_email,
          to: @email_ctx.to_email,
          bcc: 'piousbox@gmail.com',
          subject: @email_ctx.subject,
          template_name: template )
  end

end


## 2022-11-10 backup
# def send_context_email ctx_id
#   @email_ctx = ::Ish::EmailContext.find ctx_id
#   template = "render/_#{@email_ctx.email_template.slug}"
#   ac = ActionController::Base.new
#   ac.instance_variable_set( :@email_ctx, @email_ctx )
#   rendered_str = ac.render_to_string("ish_manager/email_templates/_#{@email_ctx.email_template.slug}")
#   @email_ctx.update( rendered_str: rendered_str, sent_at: Time.now )
#   mail( to: @email_ctx.to_email,
#         bcc: 'piousbox@gmail.com',
#         subject: @email_ctx.subject,
#         template_name: template )
# end
