
class ::IshManager::EmailFiltersController < ::IshManager::ApplicationController

  # before_action :set_lists

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

  def edit
    @email_filter = Office::EmailFilter.find params[:id]
    authorize! :edit, @email_filter
  end

  def index
    authorize! :index, Office::EmailFilter.new
    @email_filters = Office::EmailFilter.active.per( current_profile.per_page )
  end

  def new
    @email_filter = Office::EmailFilter.new
    authorize! :new, @email_filter
  end

  def update
    @email_filter = Office::EmailFilter.find params[:id]
    authorize! :update, @email_filter
    @email_filter.update_attributes( params[:email_filter].permit! )
    if @email_filter.persisted?
      flash[:notice] = 'Success'
    else
      flash[:alert] = "No luck: #{@email_filter.errors.full_messages.join(', ')}."
    end
    redirect_to action: 'index'
  end

end

