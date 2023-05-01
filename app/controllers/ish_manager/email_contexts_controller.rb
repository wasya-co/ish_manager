require 'csv'

class ::IshManager::EmailContextsController < ::IshManager::ApplicationController

  # Alphabetized : )

  before_action :set_lists

  def create
    @ctx    = ::Ish::EmailContext.new params[:ctx].permit!
    @tmpl   = ::Ish::EmailTemplate.find @ctx.email_template_id

    @ctx.from_email ||= @tmpl.from_email
    @ctx.subject    ||= @tmpl.subject

    authorize! :create, @ctx
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
    @body = @ctx.body

    render layout: false
  end

  def index
    authorize! :index, ::Ish::EmailContext
    @ctxs = ::Ish::EmailContext.all.page( params[:ctxs_page] ).per( 100 )

    if my_truthy? params[:sent]
      @ctxs = @ctxs.where( :sent_at.ne => nil )
    else
      @ctxs = @ctxs.where( sent_at: nil )
    end

    if params[:lead_id]
      @lead = Lead.find params[:lead_id]
      @ctxs = @ctxs.where( to_email: @lead.email )
    end
  end

  def new
    authorize! :new, ::Ish::EmailContext
    @tmpl = @email_template = Ish::EmailTemplate.where( slug: params[:template_slug] ).first ||
      Ish::EmailTemplate.where( id: params[:template_slug] ).first ||
      Ish::EmailTemplate.new
    attrs = {}
    if @tmpl
      attrs = @tmpl.attributes.slice( :subject, :body, :from_email )
    end
    @ctx = ::Ish::EmailContext.new({ email_template: @tmpl }.merge(attrs))
  end

  def show
    @ctx = @email_context = ::Ish::EmailContext.find( params[:id] )
    authorize! :show, @ctx
  end

  def summary
    authorize! :summary, Ish::EmailContext
    @results = Ish::EmailContext.summary

    respond_to do |format|
      format.html
      format.csv do
        render layout: false
      end
    end
  end

  def update
    @ctx = ::Ish::EmailContext.find params[:id]
    authorize! :update, @ctx

    if @ctx.update_attributes params[:ctx].permit!
      flash[:notice] = 'Saved.'
      redirect_to action: 'edit', id: @ctx.id
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

