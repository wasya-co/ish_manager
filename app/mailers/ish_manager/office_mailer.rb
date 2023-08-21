
class IshManager::OfficeMailer < IshManager::ApplicationMailer
  default from: 'WasyaCo Consulting & Software Development <hello@wasya.co>'

  ## 2023-04-02 _vp_ Continue.
  def send_context_email ctx_id
    @ctx = Ctx.find ctx_id

    @utm_tracking_str = {
      'cid'          => @ctx.lead_id,
      'utm_campaign' => @ctx.tmpl.slug,
      'utm_medium'   => 'email',
      'utm_source'   => @ctx.tmpl.slug,
    }.map { |k, v| "#{k}=#{v}" }.join("&")

    ac   = ActionController::Base.new
    ac.instance_variable_set( :@ctx, @ctx )
    ac.instance_variable_set( :@lead, @ctx.lead )
    ac.instance_variable_set( :@utm_tracking_str, @utm_tracking_str )

    if 'plain' == @ctx.tmpl.layout
      rendered_str = ERB.new( @ctx.body ).result( @ctx.get_binding )
    else
      rendered_str = ac.render_to_string("ish_manager/email_templates/_#{@ctx.tmpl.layout}")
    end
    @ctx.update({
      rendered_str: rendered_str,
      sent_at: Time.now.to_s,
    })

    mail( from: @ctx.from_email,
          to: @ctx.to_email,
          subject: ERB.new( @ctx.subject ).result( @ctx.get_binding ),
          body: rendered_str,
          content_type: "text/html" )
  end

end
