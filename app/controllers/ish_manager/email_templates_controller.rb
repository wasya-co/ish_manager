
class ::IshManager::EmailTemplatesController < ::IshManager::ApplicationController

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

  def iframe_src
    authorize! :iframe_src, Ish::EmailTemplate
  end

  def index
    authorize! :index, Ish::EmailTemplate
    @templates = Ish::EmailTemplate.all.page( params[:templates_page] )
  end

  def show
    authorize! :show, Ish::EmailTemplate
    @email_ctx = EmailContext.new
    @template = Ish::EmailTemplate.where({ id: params[:id] }).first || Ish::EmailTemplate.find_by({ slug: params[:id] })
    # render params[:id], layout: false
  end


end
