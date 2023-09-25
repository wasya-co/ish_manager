
class ::IshManager::EmailTemplatesController < ::IshManager::ApplicationController

  # before_action :set_lists, only: %i| new |

  def create
    authorize! :create, ::Ish::EmailTemplate
    template = ::Ish::EmailTemplate.create params[:ish_email_template].permit!
    if template.persisted?
      flash[:notice] = 'Success.'
    else
      flash[:alert] = "Could not create an email template: #{template.errors.full_messages.join(', ')}."
    end
    redirect_to action: :index
  end

  def destroy
    authorize! :destroy, ::Ish::EmailTemplate
    @template = Ish::EmailTemplate.where({ id: params[:id] }).first || Ish::EmailTemplate.find_by({ slug: params[:id] })
    if @template.destroy
      flash[:notice] = 'Success.'
    else
      flash[:alert] = 'Cannot destroy this template.'
    end
    redirect_to action: :index
  end

  def edit
    @tmpl = @email_template = Ish::EmailTemplate.where({ id: params[:id] }).first
    authorize! :edit, @tmpl
  end

  def iframe_src
    @tmpl = @email_template = Ish::EmailTemplate.where({ id: params[:id] }).first ||
      Ish::EmailTemplate.find_by({ slug: params[:id] })
    authorize! :iframe_src, @email_template

    @lead        = Lead.find_by({ email: 'poxlovi@gmail.com' })
    @ctx         = Ctx.new({ email_template: @tmpl, lead_id: @lead.id })
    @tmpl_config = OpenStruct.new JSON.parse( @ctx.tmpl[:config_json] )

    @utm_tracking_str = {
      'cid'          => @ctx.lead_id,
      'utm_campaign' => @ctx.tmpl.slug,
      'utm_medium'   => 'email',
      'utm_source'   => @ctx.tmpl.slug,
    }.map { |k, v| "#{k}=#{v}" }.join("&")

    @unsubscribe_url = Ishapi::Engine.routes.url_helpers.email_unsubscribes_url({
      template_id: @ctx.tmpl.id,
      lead_id:     @lead.id,
      token:       @lead.unsubscribe_token,
    })

    render layout: false
  end

  def index
    authorize! :index, Ish::EmailTemplate
    @templates = Ish::EmailTemplate.all.order_by( slug: :asc ).page( params[:templates_page] ).per( current_profile.per_page )
  end

  def new
    @new_email_template = Ish::EmailTemplate.new
    authorize! :new, Ish::EmailTemplate
  end

  def show
    authorize! :show, Ish::EmailTemplate
    @templates = Ish::EmailTemplate.all.page( params[:templates_page] )

    @tmpl = @email_template = Ish::EmailTemplate.where({ id: params[:id] }).first ||
      Ish::EmailTemplate.find_by({ slug: params[:id] })
    @ctx = @email_context = ::Ish::EmailContext.new({ body: Ish::LoremIpsum.html })
  end

  def update
    @template = Ish::EmailTemplate.where({ id: params[:id] }).first
    authorize! :update, @template
    flag = @template.update_attributes( params[:ish_email_template].permit! )
    if flag
      flash[:notice] = 'Success.'
    else
      flash[:alert] = "No luck. #{@template.errors.full_messages.join(', ')}"
    end
    redirect_to action: :edit
  end

  ##
  ## private
  ##
  private

end
