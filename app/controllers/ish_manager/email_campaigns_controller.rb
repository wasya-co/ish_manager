
##
## Campaigns send individual contexts to leads.
##
class ::IshManager::EmailCampaignsController < IshManager::ApplicationController

  before_action :set_lists

  def create
    @campaign = Ish::EmailCampaign.new params[:campaign].permit!
    authorize! :create, @campaign
    if @campaign.save
      flash[:notice] = "created campaign"
    else
      flash[:alert] = "Cannot create campaign: #{@campaign.errors.messages}"
    end
    redirect_to :action => 'index'
  end

  def do_send
    @campaign = Ish::EmailCampaign.find params[:id]
    authorize! :send, @campaign
    @campaign.do_send
  end

  def edit
    @campaign = Ish::EmailCampaign.find params[:id]
    authorize! :edit, @campaign
  end

  def index
    authorize! :index, Ish::EmailCampaign
    @campaigns = Ish::EmailCampaign.all
  end

  def new
    @campaign = Ish::EmailCampaign.new
    authorize! :new, @campaign
  end

  def show
    @campaign = Ish::EmailCampaign.find params[:id]
    authorize! :show, @campaign
    @leads = @campaign.leads
    if params[:q].present?
      @leads = @leads.where(" email LIKE ? ", "%#{params[:q]}%" )
    end
    @leads = @leads.page( params[:leads_page ] ).per( current_profile.per_page )
  end

  def update
    @campaign = Ish::EmailCampaign.find params[:id]
    authorize! :update, @campaign
    if @campaign.update_attributes params[:campaign].permit!
      flash[:notice] = 'Successfully updated campaign.'
    else
      flash[:alert] = "Cannot update campaign: #{@campaign.errors.messages}"
    end
    redirect_to :action => 'index'
  end

end
