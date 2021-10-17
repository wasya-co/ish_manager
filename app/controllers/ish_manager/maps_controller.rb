
class IshManager::MapsController < IshManager::ApplicationController

  before_action :set_map, only: [:destroy, :edit, :map_editor, :show, :update, ]

  def index
    authorize! :index, ::Gameui::Map
    @maps = ::Gameui::Map.where( parent_slug: "" ).order( slug: :asc )
    @all_maps = Gameui::Map.all.order( slug: :asc )
  end

  def show
    authorize! :show, @map
    @maps = Gameui::Map.where( parent_slug: @map.slug )
  end

  def new
    authorize! :new, ::Gameui::Map
    @map = ::Gameui::Map.new
  end

  def edit
    authorize! :edit, @map
  end

  def create
    @map = ::Gameui::Map.new(map_params)

    if params[:image]
      image = ::Ish::ImageAsset.new :image => params[:image]
      @map.image = image
      image.save
    end

    if map_params[:parent_slug].present?
      @map.parent = ::Gameui::Map.find_by({ slug: map_params[:parent_slug] })
    end
    authorize! :create, @map

    respond_to do |format|
      if @map.save
        format.html { redirect_to map_path(@map), notice: 'Map was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    authorize! :update, @map

    if params[:image]
      image = ::Ish::ImageAsset.new :image => params[:image]
      @map.image = image
    end

    respond_to do |format|
      if map_params[:parent_slug].present?
        @map.parent = ::Gameui::Map.find_by({ slug: map_params[:parent_slug] })
      else
        @map.parent = nil
      end
      if @map.update(map_params)
        format.html { redirect_to map_path(@map), notice: 'Map was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    authorize! :destroy, @map
    @map.destroy
    respond_to do |format|
      format.html { redirect_to maps_path, notice: 'Map was successfully destroyed.' }
    end
  end

  def map_editor
    authorize! :update, @map
  end

  private

    def set_map
      @map = ::Gameui::Map.where(id: params[:id]).first
      @map ||= Gameui::Map.find_by(slug: params[:id])
    end

    def map_params
      params.require(:gameui_map).permit!
    end

end
