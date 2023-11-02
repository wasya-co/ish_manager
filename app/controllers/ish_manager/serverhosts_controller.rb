
class ::IshManager::ServerhostsController < IshManager::ApplicationController

  before_action :set_lists

  def create
    @serverhost = Wco::Serverhost.new params[:serverhost].permit!
    authorize! :create, @serverhost

    flag = @serverhost.save
    if flag
      flash[:notice] = 'Success.'
      redirect_to action: :index
    else
      flash[:alert] = "Cannot create serverhost: #{@serverhost.errors.full_messages.join(', ')}."
      render action: :index
    end
  end

  def edit
    @serverhost = Wco::Serverhost.find params[:id]
    authorize! :edit, @serverhost
  end

  def index
    authorize! :index, Wco::Serverhost
    @serverhosts = Wco::Serverhost.all
    @new_serverhost = Wco::Serverhost.new
  end

  def show
    @serverhost = Wco::Serverhost.find params[:id]
    authorize! :show, @serverhost
  end

  def update
    @serverhost = Wco::Serverhost.find params[:id]
    authorize! :update, @serverhost
    flag = @serverhost.update_attributes params[:serverhost].permit!
    if flag
      flash[:notice] = "Success."
      redirect_to action: :index
    else
      flash[:alert] = "Cannot update serverhost: #{@serverhost.errors.full_messages.join(', ')}."
      render action: :edit
    end
  end



  ##
  ## private
  ##
  private

  def set_lists
    # super

    # @new_serverhost = Wco::Serverhost.new
    # puts! @new_serverhost.class, 'ze'
    # puts! @new_serverhost, '@new_serverhost'
    # @new_serverhost.name = 'some name'

    @wco_leadsets_list = [[nil,nil]] + Wco::Leadset.all.map { |i| [ i.name, i.id ] }
  end

end

