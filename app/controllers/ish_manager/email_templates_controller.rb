
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
    render layout: false
  end

  def index
    authorize! :index, Ish::EmailTemplate
    @templates = Ish::EmailTemplate.all.order_by( slug: :asc ).page( params[:templates_page] )
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
