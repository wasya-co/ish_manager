
class ::IshManager::EmailFiltersController < ::IshManager::ApplicationController

  before_action :set_lists

  # alphabetized : )

  def create
    authorize! :create, Office::EmailFilter
    @email_filter = Office::EmailFilter.create params[:email_filter].permit!
    if @email_filter.persisted?
      flash[:notice] = 'Success'
    else
      flash[:alert] = "No luck: #{@email_filter.errors.full_messages.join(', ')}."
    end
    redirect_to action: 'index'
  end

  def destroy
    @email_filter = Office::EmailFilter.find params[:id]
    authorize! :destroy, @email_filter
    flag = @email_filter.destroy
    if flag
      flash[:notice] = 'Success'
    else
      flash[:alert] = 'Error'
    end
    redirect_to action: 'index'
  end

  def edit
    @email_filter = Office::EmailFilter.find params[:id]
    authorize! :edit, @email_filter
  end

  def index
    authorize! :index, Office::EmailFilter.new
    @email_filters = Office::EmailFilter.active
  end

  def new
    @email_filter = Office::EmailFilter.new
    authorize! :new, @email_filter
  end

  def update
    @email_filter = Office::EmailFilter.find params[:id]
    authorize! :update, @email_filter
    flag = @email_filter.update_attributes( params[:email_filter].permit! )
    if flag
      flash[:notice] = 'Success'
    else
      flash[:alert] = "No luck: #{@email_filter.errors.full_messages.join(', ')}."
    end
    redirect_to action: 'index'
  end

end

