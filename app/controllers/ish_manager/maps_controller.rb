
class IshManager::MapsController < IshManager::ApplicationController

  before_action :set_map, only: [:show, :edit, :update, :destroy]

  def index
    authorize! :index, ::Gameui::Map
    @maps = ::Gameui::Map.all
  end

  def show
    authorize! :show, @map
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
    authorize! :create, @map

    respond_to do |format|
      if @map.save
        format.html { redirect_to gameui_map_path(@map.id), notice: 'Map was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    authorize! :update, @map
    respond_to do |format|
      if @map.update(map_params)
        format.html { redirect_to @map, notice: 'Map was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    authorize! :destroy, @map
    @map.destroy
    respond_to do |format|
      format.html { redirect_to gameui_maps_path, notice: 'Map was successfully destroyed.' }
    end
  end

  private

    def set_map
      @map = ::Gameui::Map.find(params[:id])
    end

    def map_params
      params.require(:gameui_map).permit!
    end

end
