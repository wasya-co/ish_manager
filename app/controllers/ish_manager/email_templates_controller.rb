
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

  def edit
    @template = Ish::EmailTemplate.where({ id: params[:id] }).first
    authorize! :edit, @template
  end

  def iframe_src
    authorize! :iframe_src, Ish::EmailTemplate
    @email_template = Ish::EmailTemplate.where({ id: params[:id] }).first ||
      Ish::EmailTemplate.find_by({ slug: params[:id] })
    @email_ctx = EmailContext.new({ body: Ish::LoremIpsum.html })
    render layout: false
  end

  def index
    authorize! :index, Ish::EmailTemplate
    @templates = Ish::EmailTemplate.all.page( params[:templates_page] )
  end

  def show
    authorize! :show, Ish::EmailTemplate
    @templates = Ish::EmailTemplate.all.page( params[:templates_page] )

    @email_template = Ish::EmailTemplate.where({ id: params[:id] }).first ||
      Ish::EmailTemplate.find_by({ slug: params[:id] })
    @email_ctx = EmailContext.new({ body: Ish::LoremIpsum.html })
  end

  def update
    @template = Ish::EmailTemplate.where({ id: params[:id] }).first
    authorize! :update, @template
    flag = @template.update_attributes( params[:ish_email_template].permit! )
    if flag
      flash[:notice] = 'Success.'
      redirect_to action: 'index'
    else
      flash[:alert] = "No luck. #{@template.errors.full_messages.join(', ')}"
      render :edit
    end
  end

end
