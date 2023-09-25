
class IshManager::OfficeMailer < IshManager::ApplicationMailer

  ## 2023-04-02 _vp_ Continue.
  ## 2023-09-24 _vp_ Continue : )
  def send_context_email ctx_id
    @ctx         = Ctx.find ctx_id
    @lead        = Lead.find @ctx.lead_id
    @tmpl_config = OpenStruct.new JSON.parse( @ctx.tmpl[:config_json] )

    @utm_tracking_str = {
      'cid'          => @ctx.lead_id,
      'utm_campaign' => @ctx.tmpl.slug,
      'utm_medium'   => 'email',
      'utm_source'   => @ctx.tmpl.slug,
    }.map { |k, v| "#{k}=#{v}" }.join("&")

    # @origin         = "https://#{Rails.application.config.action_mailer.default_url_options[:host]}"

    @unsubscribe_url = Ishapi::Engine.routes.url_helpers.email_unsubscribes_url({
      template_id: @ctx.tmpl.id,
      lead_id:     @lead.id,
      token:       @lead.unsubscribe_token,
    })
    # renderer = Tmp6Ctl.new
    # renderer = IshManager::ApplicationController.new
    # renderer.send( :include, ::IshManager::ApplicationHelper )
    # renderer.send( :request, { host: 'test-host' } )
    renderer = IshManager::ApplicationMailer.new

    renderer.instance_variable_set( :@ctx,              @ctx )
    renderer.instance_variable_set( :@lead,             @ctx.lead )
    renderer.instance_variable_set( :@utm_tracking_str, @utm_tracking_str )
    renderer.instance_variable_set( :@unsubscribe_url,  @unsubscribe_url )
    renderer.instance_variable_set( :@tmpl_config,      @tmpl_config )

    # eval( @ctx.tmpl.config_exe )

    if 'plain' == @ctx.tmpl.layout
      rendered_str = ERB.new( @ctx.body ).result( @ctx.get_binding )
    else
      rendered_str = renderer.render_to_string("ish_manager/email_templates/_#{@ctx.tmpl.layout}")
    end
    @ctx.update({
      rendered_str: rendered_str,
      sent_at: Time.now.to_s,
    })

    mail( from:    @ctx.from_email,
          to:      @ctx.to_email,
          subject: ERB.new( @ctx.subject ).result( @ctx.get_binding ),
          body:    rendered_str,
          content_type: "text/html" )
  end

end
