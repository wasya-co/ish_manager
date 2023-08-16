
class ::IshManager::LeadsController < IshManager::ApplicationController

  before_action :set_lists

  ## alphabetized : )

  def bulkop
    authorize! :bulkop, ::Lead
    case params[:op]
    when Lead::OP_ADD_TO_CAMPAIGN
      c = Ish::EmailCampaign.find params[:email_campaign_id]
      params[:lead_ids].each do |lead_id|
        c_lead = EmailCampaignLead.new( lead_id: lead_id, email_campaign_id: c.id )
        flag = c_lead.save
        if !flag
          puts! c_lead.errors.full_messages.join(", ")
        end
      end
      flash[:notice] = 'Done acted; See logs.'
      redirect_to action: :index

    when Lead::OP_DELETE
      outs = []
      params[:lead_ids].each do |lead_id|
        lead = Lead.find( lead_id )
        outs.push lead.discard
      end
      flash[:notice] = "Outcomes: #{outs.inspect}."
      redirect_to action: :index

    else
      throw "Unknown op: #{params[:op]}."

    end
  end

  def create
    @lead = ::Lead.new params[:lead].permit!
    authorize! :create, @lead
    if @lead.save
      flash[:notice] = "created lead"
    else
      flash[:alert] = "Cannot create lead: #{@lead.errors.messages}"
    end
    redirect_to :action => 'index'
  end

  def edit
    @lead = ::Lead.find params[:id]
    authorize! :edit, @lead
  end

  def import
    authorize! :import, ::Lead
    file   = params[:csv_file]

    ## 2023-04-08
    flags = Lead.import_v1( file )

    flash[:notice] = "Result: #{flags.inspect}."
    redirect_to action: 'new'
  end

  def index
    authorize! :index, ::Lead
    @leads = ::Lead.kept.includes( :company )
    if params[:q].present?
      @leads = @leads.where(" email LIKE ? or name LIKE ? ", "%#{params[:q]}%", "%#{params[:q]}%" )
    end
    @leads = @leads.page( params[:leads_page ] ).per( current_profile.per_page )

    # @email_contexts = {}
    # # lead_emails = @leads.map( &:email ).compact.reject(&:empty?)
    # lead_ids = @leads.map( &:id )
    # map = %Q{
    #   function() {
    #     emit(''+this.lead_id, {count: 1})
    #   }
    # }
    # reduce = %Q{
    #   function(key, values) {
    #     var result = {count: 0};
    #     values.forEach(function(value) {
    #       result.count += value.count;
    #     });
    #     return result;
    #   }
    # }
    # tmp_contexts = Ish::EmailContext.all.where( :lead_id.in => lead_ids
    #   ).map_reduce( map, reduce
    #   ).out( inline: 1 ## From: https://www.mongodb.com/docs/mongoid/current/reference/map-reduce/
    #   ).to_a
    # tmp_contexts.map { |x| @email_contexts[x[:_id]] = x[:value][:count].to_i }

  end

  def new
    @new_lead = ::Lead.new
    authorize! :new, @new_lead
  end

  def show
    @lead = Lead.find params[:id]
    authorize! :show, @lead
    @schs = Sch.where( lead_id: @lead.id )
    @ctxs = Ctx.where( lead_id: @lead.id )
    @msgs = Msg.where( from: @lead.email )
  end

  def update
    @lead = ::Lead.find params[:id]
    authorize! :update, @lead
    if @lead.update_attributes params[:lead].permit!
      flash[:notice] = 'Successfully updated lead.'
    else
      flash[:alert] = "Cannot update lead: #{@lead.errors.messages}"
    end
    ## 2023-05-14 NOT redirecting to index anymore.
    redirect_to :action => 'show', id: @lead.id
  end

end
