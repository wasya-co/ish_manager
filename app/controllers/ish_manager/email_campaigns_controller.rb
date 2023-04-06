
class ::IshManager::EmailCampaignsController < IshManager::ApplicationController

  before_action :set_lists

  def index
    authorize! :index, Ish::EmailCampaign
    @campaigns = Ish::EmailCampaign.all
  end

  def new
    @campaign = Ish::EmailCampaign.new
    authorize! :new, @campaign
  end

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

  def show
    @campaign = Ish::EmailCampaign.find params[:id]
    authorize! :show, @campaign
  end

  def edit
    @campaign = Ish::EmailCampaign.find params[:id]
    authorize! :edit, @campaign
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
