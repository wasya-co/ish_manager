
class IshManager::ScheduledEmailsController < IshManager::ApplicationController

  before_action :set_lists

  layout 'ish_manager/application_fullwidth'

  def create
    puts! params, 'params'

    authorize! :scheduled_emails_create, ::IshManager

    @scheduled = Office::ScheduledEmail.new({
      lead_id: params[:lead_id],
      interval: params[:interval],
      email_template_id: params[:template_id],
    })

    flag = @scheduled.save
    if flag
      flash[:notice] = 'Success'
    else
      flash[:alert] = "No luck: #{@scheduled.errors.full_messages.join(', ')}"
    end
    redirect_to request.referrer ? request.referrer : leadsets_path
  end

  def index
    authorize! :scheduled_emails_index, ::IshManager
    @scheduled_emails = ::Office::ScheduledEmail.all
  end

  def new
    authorize! :scheduled_emails_new, ::IshManager
    @scheduled_email = ::Office::ScheduledEmail.new
  end

  ##
  ## private
  ##
  private

  def set_lists
    @leads_list = Lead.all.map { |lead| [ lead.email, lead.id ] }
    @templates_list = Ish::EmailTemplate.all.map { |t| [ t.slug, t.id ] }
  end

end

