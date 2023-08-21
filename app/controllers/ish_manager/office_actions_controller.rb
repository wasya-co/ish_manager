
class ::IshManager::OfficeActionsController < IshManager::ApplicationController

  before_action :set_lists

  ## Alphabetized : )

  def create
    @new_office_action = Office::Action.new params[:office_action].permit!
    authorize! :create, @new_office_action
    flag = @new_office_action.save
    if flag
      flash[:notice] = "Created OAction."
      redirect_to action: 'index'
    else
      flash[:alert] = "Cannot create OAction: #{@new_office_action.errors.full_messages.join(', ')}."
      render action: 'new'
    end
  end

  def edit
    @act = @office_action = Office::Action.find( params[:id] )
    @act.ties.push Office::ActionTie.new( next_office_action_id: nil )
    authorize! :edit, @act
  end

  def index
    @office_actions = Office::Action.all

    authorize! :index, @new_office_action
  end

  def new
    authorize! :new, @new_office_action
  end

  def show
    @act = @office_action = Office::Action.find( params[:id] )
    authorize! :show, @act
  end

  ## def create; update; end
  ## def upsert; update; end
  def update
    if params[:id]
      @act = @office_action = Office::Action.find( params[:id] )
    else
      @act = @office_action = Office::Action.new
    end
    authorize! :upsert, @act

    if params[:office_action][:ties_attributes]
      params[:office_action][:ties_attributes].each do |k, v|
        if !v[:next_office_action_id].present?
          params[:office_action][:ties_attributes].delete( k )
        end
        if v[:to_delete] == "1"
          EActie.find( v[:id] ).delete
          params[:office_action][:ties_attributes].delete( k )
        end
      end
    end

    flag = @act.update_attributes( params[:office_action].permit! )
    if flag
      flash[:notice] = 'Success'
      redirect_to action: 'index'
    else
      flash[:alert] = "No luck: #{@act.errors.full_messages.join(', ')}. #{@act.ties.map { |t| t.errors.full_messages.join(', ') }.join(' | ') }"
      render action: 'edit'
    end

  end

  ##
  ## private
  ##
  private

  def set_lists
    @new_office_action = Office::Action.new
    super
  end

end
