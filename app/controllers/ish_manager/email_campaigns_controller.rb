
class ::IshManager::EmailCampaignsController < IshManager::ApplicationController

  def do_send

    # case @ctx.type
    # when ::Ish::EmailContext::TYPE_SINGLE
    #   flash[:notice] = 'Scheduled a single send - v2'
    #   @ctx.send_at = Time.now
    #   @ctx.save
    # when ::Ish::EmailContext::TYPE_CAMPAIGN
    #   flash[:notice] = 'Scheduled campaign send'
    #   IshManager::EmailCampaignJob.new.perform(params[:id])
    # end
  end

  def index
    authorize! :index, Ish::EmailCampaign
    @campaigns = Ish::EmailCampaign.where( :profile => @current_profile, :is_trash => false )
    if params[:is_done]
      @campaigns = @campaigns.where( :is_done => true )
    else
      @campaigns = @campaigns.where( :is_done => false )
    end
  end

  def new
    @new_campaign = Ish::EmailCampaign.new
    authorize! :new, @new_campaign
  end

  def create
    @campaign = Ish::EmailCampaign.new params[:campaign].permit!
    @campaign.profile = @current_profile
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
