
class IshManager::OfficeMailer < IshManager::ApplicationMailer

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
