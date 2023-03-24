
class ::IshManager::EmailActionsController < IshManager::ApplicationController

  before_action :set_lists

  ## Alphabetized : )

  def create
    @act = @email_action = Office::EmailAction.new
    authorize! :create, @act

    next_ids = params[:email_action].delete(:next_email_actions)
    next_ids.delete("")
    Office::EmailAction.where(prev_email_action_id: params[:id] ).update_all(prev_email_action_id: nil)
    next_ids.each do |next_id|
      next_action = ::Office::EmailAction.find next_id
      next_action.update_attribute( :prev_email_action_id, params[:id] )
    end

    flag = @act.update_attributes( params[:email_action].permit! )
    if flag
      flash[:notice] = 'Success'
    else
      flash[:alert] = "No luck: #{@act.errors.full_messages.join(', ')}"
    end

    redirect_to action: 'index'
  end

  def edit
    @act = @email_action = Office::EmailAction.find( params[:id] )
    @act.ties.push Office::EmailActionTie.new( next_email_action_id: nil )
    authorize! :edit, @act
  end

  def index
    @email_actions = Office::EmailAction.all

    authorize! :index, @new_email_action
  end

  def new
    authorize! :new, @new_email_action
  end

  def show
    @act = @email_action = Office::EmailAction.find( params[:id] )
    authorize! :show, @act
  end

  def update
    @act = @email_action = Office::EmailAction.find( params[:id] )
    authorize! :update, @act

    params[:email_action][:ties_attributes].each do |k, v|
      if !v[:next_email_action_id].present?
        params[:email_action][:ties_attributes].delete( k )
      end
      if v[:to_delete] == "1"
        Actie.find( v[:id] ).delete
        params[:email_action][:ties_attributes].delete( k )
      end
    end

    flag = @act.update_attributes( params[:email_action].permit! )
    if flag
      flash[:notice] = 'Success'
    else
      flash[:alert] = "No luck: #{@act.errors.full_messages.join(', ')}. #{@act.ties.map { |t| t.errors.full_messages.join(', ') }.join(' | ') }"
    end

    redirect_to action: 'index'
  end

  ##
  ## private
  ##
  private

  def set_lists
    @new_email_action = Office::EmailAction.new
    super
  end

end
