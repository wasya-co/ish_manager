
class ::IshManager::Office::EmailCampaignsController < IshManager::ApplicationController

  def index
    authorize! :index, Ish::Campaign
    @campaigns = Ish::Campaign.where( :profile => current_user.profile, :is_trash => false )
    if params[:is_done]
      @campaigns = @campaigns.where( :is_done => true )
    else
      @campaigns = @campaigns.where( :is_done => false )
    end
  end

  def new
    @new_campaign = Ish::Campaign.new
    authorize! :new, @new_campaign
  end

  def create
    @campaign = Ish::Campaign.new params[:campaign].permit!
    @campaign.profile = current_user.profile
    authorize! :create, @campaign
    if @campaign.save
      flash[:notice] = "created campaign"
    else
      flash[:alert] = "Cannot create campaign: #{@campaign.errors.messages}"
    end
    redirect_to :action => 'index'
  end

  def show
    authorize! :redirect, IshManager::Ability
    redirect_to :action => :edit, :id => params[:id]
  end

  def edit
    @campaign = Ish::Campaign.find params[:id]
    authorize! :edit, @campaign
  end

  def update
    @campaign = Ish::Campaign.find params[:id]
    authorize! :update, @campaign
    if @campaign.update_attributes params[:campaign].permit!
      flash[:notice] = 'Successfully updated campaign.'
    else
      flash[:alert] = "Cannot update campaign: #{@campaign.errors.messages}"
    end
    redirect_to :action => 'index'
  end

end
