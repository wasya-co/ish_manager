
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
    param_lead_tags = params[:lead].delete :lead_tags
    param_photo     = params[:lead].delete :photo
    @lead = ::Lead.new params[:lead].permit!
    authorize! :create, @lead

    param_lead_tags.delete ''
    lead_tags = LeadTag.where({ lead_id: @lead.id })
    if param_lead_tags.map(&:to_i).sort != lead_tags.map(&:term_id).sort
      lead_tags.map(&:destroy)
      param_lead_tags.each do |lt|
        LeadTag.create({ lead_id: @lead.id, term_id: lt })
      end
    end

    if param_photo
      photo = Photo.create photo: param_photo
      @lead.photo_id  = photo.id
      # @lead.photo_url = photo.photo.url(:small)
    end

    if @lead.save
      flash[:notice] = "created lead"
      redirect_to action: :show, id: @lead.id
    else
      flash[:alert] = "Cannot create lead: #{@lead.errors.messages}"
      render action: :new
    end
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
    if params[:q_tag_ids].present?
      carry = nil
      params[:q_tag_ids].each do |term_id|
        lts = LeadTag.where({ term_id: term_id }).map(&:lead_id)
        if carry
          carry = carry & lts
        else
          carry = lts
        end
      end
      @leads = Lead.where({ :id.in => carry })
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
    @lead = ::Lead.new
    authorize! :new, @lead
  end

  def show
    @lead = Lead.find params[:id]
    authorize! :show, @lead
    @schs = Sch.where( lead_id: @lead.id )
    @ctxs = Ctx.where( lead_id: @lead.id )
    @msgs = Msg.where( from: @lead.email )
    @galleries = @lead.galleries.page( params[:galleries_page] ).per( current_profile.per_page )
    @videos    = @lead.videos.page( params[:videos_page]       ).per( current_profile.per_page )
  end

  def update
    param_lead_tags = params[:lead].delete :lead_tags
    param_photo     = params[:lead].delete :photo
    @lead = ::Lead.find params[:id]
    authorize! :update, @lead

    param_lead_tags.delete ''
    lead_tags = LeadTag.where({ lead_id: @lead.id })
    if param_lead_tags.map(&:to_i).sort != lead_tags.map(&:term_id).sort
      lead_tags.map(&:destroy)
      param_lead_tags.each do |lt|
        LeadTag.create({ lead_id: @lead.id, term_id: lt })
      end
    end

    if param_photo
      photo = Photo.create photo: param_photo
      @lead.photo_id  = photo.id
      # @lead.photo_url = photo.photo.url(:small)
    end

    if @lead.update_attributes params[:lead].permit!
      flash[:notice] = 'Successfully updated lead.'
      redirect_to :action => 'show', id: @lead.id
    else
      flash[:alert] = "Cannot update lead: #{@lead.errors.messages}"
      render action: :edit
    end
  end

end
