
class ::IshManager::EmailCampaignLeadsController < IshManager::ApplicationController

  # before_action :set_lists

  ## alphabetized : )

  # def bulkop
  #   authorize! :bulkop, ::Lead
  #   case params[:a]
  #   when 'add_to_campaign'
  #     c = EmailCampaign.find params[:email_campaign_id]
  #     params[:lead_ids].each do |lead_id|
  #       c_lead = EmailCampaignLead.new( lead_id: lead_id, email_campaign_id: c.id )
  #       flag = c_lead.save
  #       if !flag
  #         puts! c_lead.errors.full_messages.join(", ")
  #       end
  #     end
  #     flash[:notice] = 'Done acted; See logs.'
  #     redirect_to action: :index
  #   end
  # end

  # def create
  #   @lead = ::Lead.new params[:lead].permit!
  #   authorize! :create, @lead
  #   if @lead.save
  #     flash[:notice] = "created lead"
  #   else
  #     flash[:alert] = "Cannot create lead: #{@lead.errors.messages}"
  #   end
  #   redirect_to :action => 'index'
  # end

  # def edit
  #   @lead = ::Lead.find params[:id]
  #   authorize! :edit, @lead
  # end

  # def index
  #   authorize! :index, ::Lead
  #   @leads = ::Lead.all.includes( :leadset )
  # end

  # def new
  #   @new_lead = ::Lead.new
  #   authorize! :new, @new_lead
  # end

  def show
    @c_lead = ::EmailCampaignLead.find params[:id]
    authorize! :show, @c_lead

  end

  # def update
  #   @lead = ::Lead.find params[:id]
  #   authorize! :update, @lead
  #   if @lead.update_attributes params[:lead].permit!
  #     flash[:notice] = 'Successfully updated lead.'
  #   else
  #     flash[:alert] = "Cannot update lead: #{@lead.errors.messages}"
  #   end
  #   redirect_to :action => 'index'
  # end

  private

  # def set_lists
  #   @leadsets_list = [ [nil,nil] ] + ::Leadset.all.map { |k| [ k.name, k.id ] }
  #   @email_campaigns_list = [ [nil,nil] ] + Ish::EmailContext.all_campaigns.map { |k| [ k.slug, k.id ] }
  # end

end
