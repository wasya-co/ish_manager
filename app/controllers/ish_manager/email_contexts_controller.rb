
class ::IshManager::EmailContextsController < ::IshManager::ApplicationController

  # alphabetized : )

  before_action :set_lists

  def create
    authorize! :create, ::Ish::EmailContext
    pparams = params[:ish_email_context].permit!
    pparams[:tmpl] = JSON.parse(pparams[:tmpl])
    @ctx = ::Ish::EmailContext.new pparams
    if @ctx.save
      flash[:notice] = 'Saved.'
      redirect_to action: 'show', id: @ctx.id
      return
    else
      # flash[:alert] = "Could not save: #{@ctx.errors.full_messages.join(', ')}"
      flash[:alert] = ['Could not save:'] + @ctx.errors.full_messages
      render action: :new
      return
    end
  end

  def destroy
    @ctx = Ish::EmailContext.find params[:id]
    authorize! :destroy, @ctx
    flag = @ctx.destroy
    if flag
      flash[:notice] = 'Destroyed the email context'
    else
      flash[:alert] = 'Could not destroy email context'
    end
    redirect_to action: :index
  end

  def do_send
    @ctx = ::Ish::EmailContext.find params[:id]
    authorize! :do_send, @ctx

    flash[:notice] = 'Scheduled a single send - v2'
    @ctx.send_at = Time.now
    @ctx.save

    redirect_to action: 'index'
  end

  def edit
    @ctx = ::Ish::EmailContext.find params[:id]
    authorize! :edit, @ctx
  end

  def iframe_src
    @ctx = @email_context = Ish::EmailContext.find params[:id]
    authorize! :iframe_src, @ctx
    @tmpl = @email_template = @ctx.email_template
    @lead = @ctx.lead
    # @body = @ctx.body_templated
    render "ish_manager/email_templates/_#{@tmpl.layout}", layout: false
  end

  def index
    authorize! :index, ::Ish::EmailContext
    @ctxs = ::Ish::EmailContext.all

    if params[:notsent]
      @ctxs = @ctxs.where( sent_at: nil )
    end

    if params[:lead_id]
      @lead = Lead.find params[:lead_id]
      @ctxs = @ctxs.where( to_email: @lead.email )
    end

    @ctxs = @ctxs.page( params[Ish::EmailContext::PAGE_PARAM_NAME] )

    render layout: 'ish_manager/application_fullwidth'
  end

  def new
    authorize! :new, ::Ish::EmailContext
    @template = Ish::EmailTemplate.where( slug: params[:template_slug] ).first
    @template ||= Ish::EmailTemplate.where( id: params[:template_slug] ).first
    attrs = {}
    if @template
      attrs = @template.attributes.slice( :subject, :body, :from_email )
    end
    @ctx = ::Ish::EmailContext.new( { email_template: @template }.merge(attrs) )
  end

  def show
    @ctx = @email_context = ::Ish::EmailContext.find( params[:id] )
    authorize! :show, @ctx
  end

  def update
    @ctx = ::Ish::EmailContext.find params[:id]
    authorize! :update, @ctx
    pparams = params[:ish_email_context].permit!

    if @ctx.update_attributes pparams
      flash[:notice] = 'Saved.'
      redirect_to action: 'show', id: @ctx.id
      return
    else
      flash[:alert] = "Could not save: #{@ctx.errors.full_messages.join(', ')}"
      render action: :edit
      return
    end
  end

  ##
  ## Private
  ##
  private

  def set_lists
    @email_templates_list = [ [nil, nil] ] + ::Ish::EmailTemplate.all.map { |tmpl| [ tmpl.slug, tmpl.id ] }
    @leads_list = Lead.list
  end

end

