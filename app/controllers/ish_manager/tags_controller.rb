
class IshManager::TagsController < IshManager::ApplicationController

  before_action :set_lists

  def index
    @tags = Tag.unscoped
    authorize! :index, Tag.new
  end
  
  def show
    @tag = Tag.unscoped.find params[:id]
    authorize! :show, @tag
  end

  def new
    @tag = Tag.new
    authorize! :new, @tag
  end

  def create
    @tag = Tag.create params[:tag].permit!
    authorize! :create, @tag
    if @tag.save
      flash[:notice] = 'Success.'
      redirect_to tags_path
    else
      puts! @tag.errors, "error creating tag."
      flash[:error] = "No luck. #{@tag.errors.messages}" 
      render :action => :new
    end
  end

  def edit
    @tag = Tag.unscoped.find params[:id]
    authorize! :edit, @tag
  end

  def update
    @tag = Tag.unscoped.find params[:id]
    authorize! :update, @tag
    if @tag.update_attributes params[:tag].permit!
      flash[:notice] = 'Success.'
      redirect_to tags_path
    else
      flash[:error] = 'No luck.'
      render :action => :new
    end
  end
  
end


