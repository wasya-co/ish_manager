
class ::IshManager::EmailContextsController < ::IshManager::ApplicationController

  # alphabetized : )

  before_action :set_lists

  def create
    authorize! :create, ::Ish::EmailContext
    @email_ctx = ::Ish::EmailContext.new params[:ish_email_context].permit!
    if @email_ctx.save
      flash[:notice] = 'Saved.'
      redirect_to action: 'show', id: @email_ctx.id
      return
    else
      flash[:alert] = "Could not save: #{@email_ctx.errors.full_messages.join(', ')}"
      render action: :new
      return
    end
  end

  def do_send
    authorize! :send, ::Ish::EmailContext
    IshManager::OfficeMailer.send_context_email(params[:id]).deliver_later
    flash[:notice] = 'Scheduled send'
    redirect_to action: 'index'
  end

  def edit
    authorize! :edit, ::Ish::EmailContext
    @email_ctx = ::Ish::EmailContext.find params[:id]
  end

  def iframe_src
    authorize! :iframe_src, Ish::EmailContext
    @email_ctx = EmailContext.find params[:id]
    @email_template = @email_ctx.email_template
    render 'ish_manager/email_templates/iframe_src', layout: false
  end

  def index
    authorize! :index, ::Ish::EmailContext
    @email_ctxs = ::Ish::EmailContext.all.page( params[Ish::EmailContext::PAGE_PARAM_NAME] )
  end

  def new
    authorize! :new, ::Ish::EmailContext
    @email_ctx = ::Ish::EmailContext.new email_template: @template
  end

  def show
    authorize! :show, ::Ish::EmailContext
    @email_ctx = ::Ish::EmailContext.find( params[:id] )
  end

  def update
    authorize! :update, ::Ish::EmailContext
    @email_ctx = ::Ish::EmailContext.find params[:id]
    if @email_ctx.update_attributes params[:ish_email_context].permit!
      flash[:notice] = 'Saved.'
      redirect_to action: 'show', id: @email_ctx.id
      return
    else
      flash[:alert] = "Could not save: #{@email_ctx.errors.full_messages.join(', ')}"
      render action: :edit
      return
    end
  end

  private

  def set_lists
    @email_templates_list = [ [nil, nil] ] + ::Ish::EmailTemplate.all.map { |tmpl| [ tmpl.slug, tmpl.id ] }
  end

end

