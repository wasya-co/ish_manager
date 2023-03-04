
class IshManager::ScheduledEmailActionsController < IshManager::ApplicationController

  before_action :set_lists

  layout 'ish_manager/application_fullwidth'

  def create
    puts! params, 'params'

    authorize! :scheduled_emails_create, ::IshManager

    @scheduled = Office::ScheduledEmailAction .new({
      lead_id: params[:lead_id],
      email_action_id: params[:email_action_id],
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
    @scheduled_email_actions = ::Office::ScheduledEmailAction.all
  end

  def new
    @scheduled_email_action = ::Office::ScheduledEmailAction.new
    authorize! :scheduled_emails_new, @scheduled_email_action
  end

end

