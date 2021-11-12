
class IshManager::MarkersController < IshManager::ApplicationController

  before_action :set_map, except: [ :destroy, :edit, :update ]
  before_action :set_marker, only: [ :edit, :update ]
  before_action :set_lists

  def new
    authorize! :new_marker, ::Gameui::Map
    @marker = ::Gameui::Marker.new
  end

  def edit
    @marker = ::Gameui::Marker.unscoped.find params[:id]
    @map = @marker.map
    authorize! :edit_marker, @map
  end

  def create
    @marker = ::Gameui::Marker.new(marker_params)
    @marker.map = @map
    authorize! :create_marker, @map
    @map_id = @map.id

    if params[:image]
      @marker.image = ::Ish::ImageAsset.new :image => params[:image]
      @marker.image.save
    end
    if params[:title_image]
      @marker.title_image = ::Ish::ImageAsset.new :image => params[:title_image]
      @marker.title_image.save
    end

    respond_to do |format|
      if @marker.save
        @marker.map.touch
        format.html { redirect_to map_path(@map), notice: 'Marker was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    authorize! :update_marker, @map

    if params[:image]
      @marker.image = ::Ish::ImageAsset.new :image => params[:image]
      @marker.image.save
    end
    if params[:title_image]
      @marker.title_image = ::Ish::ImageAsset.new :image => params[:title_image]
      @marker.title_image.save
    end

    respond_to do |format|
      if @marker.update(marker_params)
        @marker.map.touch
        format.html { redirect_to location_map_editor_path(@map.id), notice: 'Marker was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @marker = ::Gameui::Marker.find params[:id]
    @map = @marker.map
    authorize! :destroy_marker, @map
    @marker.map.touch
    @marker.destroy
    respond_to do |format|
      format.html { redirect_to map_path(@map), notice: 'Marker was successfully destroyed.' }
    end
  end

  private

  def set_map
    @map = ::Gameui::Map.find(params[:map_id] || params[:gameui_marker][:map_id])
  end

  def set_marker
    @marker = ::Gameui::Marker.unscoped.find params[:id]
    @map = @marker.map
  end

  def marker_params
    out = params.require(:gameui_marker).permit!

    out[:shared_profiles].delete('') if out[:shared_profiles]
    if out[:shared_profiles].present?
      out[:shared_profiles] = Ish::UserProfile.find( out[:shared_profiles] )
    end

    out
  end

end
