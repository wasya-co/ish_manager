
class IshManager::MarkersController < IshManager::ApplicationController

  before_action :set_map # , only: [:show, :edit, :update, :destroy, :new, :create ]

  def index
    authorize! :markers, ::Gameui::Map
  end

=begin
  def show
    authorize! :show_marker, @map
  end
=end

  def new
    authorize! :new_marker, ::Gameui::Map
    @marker = ::Gameui::Marker.new
    puts! params, 'params'
  end

  def edit
    authorize! :edit_marker, @map
  end

  def create
    @marker = ::Gameui::Marker.new(marker_params)
    @marker.map = @map
    authorize! :create_marker, @map
    @map_id = @map.id

    respond_to do |format|
      if @marker.save
        format.html { redirect_to gameui_map_path(@map.id), notice: 'Marker was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    authorize! :update_marker, @map
    respond_to do |format|
      if @maprker.update(marker_params)
        format.html { redirect_to @map, notice: 'Marker was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    authorize! :destroy_marker, @map
    @marker.destroy
    respond_to do |format|
      format.html { redirect_to maps_url, notice: 'Marker was successfully destroyed.' }
    end
  end

  private

    def set_map
      puts! params, 'params'
      puts! params[:map_id], 'params[:map_id]'

      @map = ::Gameui::Map.find(params[:map_id] || params[:gameui_marker][:map_id])
    end

    def marker_params
      params.require(:gameui_marker).permit(:slug, :w, :h, :x, :y, :description, :img_path)
    end

end
