
class Manager::TagsController < Manager::ManagerController

  before_filter :set_lists

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
    @tag = Tag.create params[:tag].permit( :name, :name_seo, :descr, :is_public, :is_feature, :is_trash,
                                           :weight, :parent_tag_id, :site_id )
    authorize! :create, @tag
    if @tag.save
      flash[:notice] = 'Success.'
      redirect_to manager_tags_path
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
    if @tag.update_attributes params[:tag].permit( :name, :name_seo, :descr,
                                                   :is_public, :is_trash, :is_feature, :weight,
                                                   :site_id, :parent_tag_id )
      flash[:notice] = 'Success.'
      redirect_to manager_tags_path
    else
      flash[:error] = 'No luck.'
      render :action => :new
    end
  end
  
end
