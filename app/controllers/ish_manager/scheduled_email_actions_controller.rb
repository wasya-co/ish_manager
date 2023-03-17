
class IshManager::ScheduledEmailActionsController < IshManager::ApplicationController

  before_action :set_lists

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

  def edit
    @sch = Sch.find params[:id]
    authorize! :edit, @sch
  end

  def index
    authorize! :scheduled_emails_index, ::IshManager
    @scheduled_email_actions = ::Office::ScheduledEmailAction.all
  end

  def new
    @scheduled_email_action = ::Office::ScheduledEmailAction.new
    authorize! :scheduled_emails_new, @scheduled_email_action
  end

  def show
    @sch = Sch.find params[:id]
    authorize! :show, @sch
    redirect_to action: 'edit'
  end

  def update
    @sch = Sch.find params[:id]
    authorize! :update, @sch
    flag = @sch.update_attributes( params[:sch].permit! )
    if flag
      flash[:notice] = "Success."
    else
      flash[:alert] = "No luck: #{@sch.errors.full_messages.join(',')}."
    end
    render action: 'edit'
  end

end

