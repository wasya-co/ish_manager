
class IshManager::MapsController < IshManager::ApplicationController

  before_action :set_map, only: [ :destroy, :edit, :export, :map_editor, :show, :update, ] # alphabetized
  before_action :set_lists

  # alphabetized

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

    if @map.save
      redirect_to map_path(@map), notice: 'Map was successfully created.'
    else
      render :new
    end
  end

  def destroy
    authorize! :destroy, @map
    @map.destroy
    respond_to do |format|
      format.html { redirect_to maps_path, notice: 'Map was successfully destroyed.' }
    end
  end

  ## @TODO: @obsolete, remove
  def edit
    authorize! :edit, @map
    redirect_to action: 'show'
  end

  def export
    authorize! :edit, @map
    result = @map.export_subtree
    send_data result
  end

  ##
  ## @TODO: move to models, yes?
  ##
  def import
    authorize! :create, Map

    file_data = params[:input]
    if file_data.respond_to?(:read)
      contents = file_data.read
    elsif file_data.respond_to?(:path)
      contents = File.read(file_data.path)
    else
      logger.error "Bad file_data: #{file_data.class.name}: #{file_data.inspect}"
    end
    contents = JSON.parse contents
    contents.deep_symbolize_keys!

    ## Delete existing
    if params[:delete_existing]
      map_ids = contents[:maps].map { |m| m[:_id] }
      marker_ids = contents[:markers].map { |m| m[:_id] }

      maps = Map.where( :_id.in => map_ids )
      maps.each do |m|
        marker_ids += m.markers.map(&:_id)
      end
      maps.destroy_all

      Marker.where( :_id.in => marker_ids ).destroy_all
    end


    ##
    ## process content
    ##
    errors = []

    # profiles
    profiles = contents[:profiles]
    contents.delete :profiles
    profiles.each do |profile|
      if Ish::UserProfile.where( _id: profile[:_id] ).first
        errors.push({ message: "profile #{profile[:email]} already exists." })
      else
        p = Profile.new({ email: profile[:email], _id: profile[:_id] })
        u = User.where( email: profile[:email] ).first
        u ||= User.new( email: profile[:email], password: rand.to_s )
        flag = u.save && p.save
        if flag
          errors.push({ message: "Profile created for #{profile[:email]}." })
        else
          errors.push({ message: u.errors.full_messages.join(", ") })
          errors.push({ message: p.errors.full_messages.join(", ") })
        end
      end
    end

    # everything else
    contents.each do |k, v|
      # puts! [k, v], "Importing"
      item = Map.export_key_to_class[k].constantize
      v.map do |inn|
        n = item.new inn
        begin
          flag = n.save
        rescue Mongo::Error::OperationFailure => e
          errors.push({ class: k, id: inn[:_id], messages: "Mongo::Error::OperationFailure :: |#{e.to_s}|" })
        end
        if flag
          errors.push({ class: k, id: inn[:_id], messages: 'ok' })
        else
          errors.push({ class: k, id: inn[:_id], messages: "Could not save: |#{n.errors.full_messages.join(", ")}|." })
        end
      end
    end

    flash[:notice] = errors
    redirect_to action: :index
  end

  def index
    authorize! :index, ::Gameui::Map

    if params[:q]
      @maps = ::Gameui::Map.or({ slug: /#{params[:q]}/i }, { name: /#{params[:q]}/i })
      if @maps.length == 1
        redirect_to map_path(@maps[0])
        return
      end
    end

    @maps ||= ::Gameui::Map.unscoped.where( parent_slug: "" ).order( slug: :asc )
    @all_maps = Gameui::Map.all.order( slug: :asc )
  end

  def map_editor
    authorize! :update, @map
  end

  def new
    authorize! :new, ::Gameui::Map
    @map = ::Gameui::Map.new
  end

  def show
    authorize! :show, @map
    @maps = Gameui::Map.where( parent_slug: @map.slug )
  end

  def update
    authorize! :update, @map

    if params[:image]
      image = ::Ish::ImageAsset.new :image => params[:image]
      @map.image = image
      image.save
    end

    @map.config = JSON.parse map_params[:config]

    # And update markers
    # @TODO: rewrite and make this one query!
    if map_marker_params.present?
      markers = Marker.where( destination: @map )
      markers.each do |m|
        map_marker_params.each do |k, v|
          m.update_attribute(k, v)
        end
      end
    end

    if map_params[:parent_slug].present?
      @map.parent = ::Gameui::Map.find_by({ slug: map_params[:parent_slug] })
    else
      @map.parent = nil
    end

    respond_to do |format|
      if @map.update(map_params)
        format.html do # format is required
          redirect_to edit_map_path(@map), notice: 'Map was successfully updated.'
        end
      else
        format.html do
          render :edit
        end
      end
    end
  end

  private

  def map_params
    out = params.require(:gameui_map).permit!

    out[:shared_profiles].delete('')
    if out[:shared_profiles].present?
      out[:shared_profiles] = Ish::UserProfile.find( out[:shared_profiles] )
    end

    out
  end

  def map_marker_params
    out = map_params.slice( :shared_profiles, :is_public )
    puts! out, 'map_marker_params'
    out
  end

  ## @TODO: remove all instances of unscoped, everywhere.
  def set_map
    @map = ::Gameui::Map.unscoped.where(id: params[:id]).first
    @map ||= Gameui::Map.unscoped.find_by(slug: params[:id])
    @markers = @map.markers.unscoped.includes( :destination )
  end

end
