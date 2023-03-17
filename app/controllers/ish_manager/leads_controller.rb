
class ::IshManager::LeadsController < IshManager::ApplicationController

  before_action :set_lists

  ## alphabetized : )

  def bulkop
    authorize! :bulkop, ::Lead
    case params[:op]
    when Lead::OP_ADD_TO_CAMPAIGN
      c = EmailCampaign.find params[:email_campaign_id]
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

  ##          0     1     2      3    4      5         6        7
  ## Fields: id, date, name, email, tag, phone, linkedin, comment
  def import
    authorize! :import, ::Lead
    file   = params[:csv_file]
    flags  = []
    errors = []
    CSV.read(file.path, headers: true).each do |row|

      leadset = ::Leadset.find_or_create_by({ company_url: row[3].split('@')[1] })
      lead = ::Lead.new({
        name: row[2].presence || row[3].split('@')[0],
        full_name: row[2].presence || row[3].split('@')[0],
        email: row[3],
        m3_leadset_id: leadset.id,
        phone: row[5],
      })
      flag = lead.save
      flags << flag
      if !flag
        errors << lead.errors.full_messages.join(", ")
      end

      if row[4].present?
        tags = row[4].split(",").map do |tag_name|
          WpTag.my_find_or_create({ name: tag_name })
        end
        puts! tags, 'tags'
        tags.each do |tag|
          LeadTag.create({ wp_tag: tag, lead: lead })
        end
      end

    end
    flash[:notice] = "Result: #{flags.inspect}."
    flash[:alert] = errors
    redirect_to action: 'new'
  end

  def index
    authorize! :index, ::Lead
    @leads = ::Lead.kept.includes( :company )
    lead_emails = @leads.map( &:email ).compact.reject(&:empty?)

    map = %Q{
      function() {
        emit(this.to_email, {count: 1})
      }
    }
    reduce = %Q{
      function(key, values) {
        var result = {count: 0};
        values.forEach(function(value) {
          result.count += value.count;
        });
        return result;
      }
    }
    @email_contexts = {}
    tmp_contexts = Ish::EmailContext.all.where( :to_email.in => lead_emails
      ).map_reduce( map, reduce
      ).out( inline: 1 ## From: https://www.mongodb.com/docs/mongoid/current/reference/map-reduce/
      ).to_a
    tmp_contexts.map { |x| @email_contexts[x[:_id]] = x[:value][:count].to_i }
    # puts! @email_contexts, '@email_contexts'

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
    redirect_to :action => 'index'
  end

end
