
class IshManager::MarkersController < IshManager::ApplicationController

  before_action :set_map, except: [ :destroy, :edit, :update ]
  before_action :set_marker, only: [ :edit, :update ]

=begin
  def index
    authorize! :markers, ::Gameui::Map
  end
=end

  def new
    authorize! :new_marker, ::Gameui::Map
    @marker = ::Gameui::Marker.new
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
      if @marker.update(marker_params)
        format.html { redirect_to @map, notice: 'Marker was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @marker = ::Gameui::Marker.find params[:id]
    @map = @marker.map
    authorize! :destroy_marker, @map
    @marker.destroy
    respond_to do |format|
      format.html { redirect_to @map, notice: 'Marker was successfully destroyed.' }
    end
  end

  private

    def set_map
      @map = ::Gameui::Map.find(params[:map_id] || params[:gameui_marker][:map_id])
    end

    def set_marker
      @marker = ::Gameui::Marker.find params[:id]
      @map = @marker.map
    end

    def marker_params
      params.require(:gameui_marker).permit!
    end

end
