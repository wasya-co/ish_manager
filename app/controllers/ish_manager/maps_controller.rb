
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
        format.html { redirect_to map_path(@map.id), notice: 'Map was successfully created.' }
        format.json { render :show, status: :created, location: @map }
      else
        format.html { render :new }
        format.json { render json: @map.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize! :update, @map
    respond_to do |format|
      if @map.update(map_params)
        format.html { redirect_to @map, notice: 'Map was successfully updated.' }
        format.json { render :show, status: :ok, location: @map }
      else
        format.html { render :edit }
        format.json { render json: @map.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize! :destroy, @map
    @map.destroy
    respond_to do |format|
      format.html { redirect_to maps_url, notice: 'Map was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_map
      @map = ::Gameui::Map.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def map_params
      params.require(:gameui_map).permit(:slug, :w, :h, :description, :img_path)
    end

end
