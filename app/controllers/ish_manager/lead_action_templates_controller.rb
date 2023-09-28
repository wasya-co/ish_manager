
class IshManager::LeadActionTemplatesController < IshManager::ApplicationController


  def create
    authorize! :create, Office::LeadActionTemplate
    @tmpl = ::Office::LeadActionTemplate.new params[:tmpl].permit!
    if @tmpl.save
      flash_notice 'saved'
    else
      flash_alert "cannot save: #{@tmpl.errors.full_messages.join(', ')}."
    end
    redirect_to action: :index
  end

  def edit
    @tmpl = Office::LeadActionTemplate.find params[:id]
    authorize! :edit, @tmpl
  end

  def index
    authorize! :index, Office::LeadActionTemplate
    @tmpls = ::Office::LeadActionTemplate.all
    @new_lat = ::Office::LeadActionTemplate.new
  end

  def new
    authorize! :new, Office::LeadActionTemplate
    @tmpl = ::Office::LeadActionTemplate.new
  end

end

