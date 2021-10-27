
class IshManager::PhotosController < IshManager::ApplicationController

  # @TODO: this is bad? _vp_ 20170513
  skip_authorization_check :only => [ :j_create ]
  protect_from_forgery :except => [ :j_create]

  def without_gallery
    @photos = Photo.unscoped.where( :gallery => nil, :is_trash => false )
  end

  def destroy
    @photo = Photo.unscoped.find params[:id]
    authorize! :destroy, @photo
    @photo.gallery.touch if @photo.gallery
    @photo.is_trash = true
    flag = @photo.save
    if flag
      flash[:notice] = "Success"
    else
      flash[:alert] = "No luck: #{@photo.errors.messages}"
    end
    redirect_to request.referrer || root_path
  end

  def show
    @photo = Photo.unscoped.find params[:id]
    authorize! :show, @photo
  end

  def j_create
    # find this gallery
    if params[:slug]
      gallery = Gallery.unscoped.where( :slug => params[:slug] ).first
      gallery ||= Gallery.unscoped.find params[:slug]
    elsif params[:gallery_id] # this one, let's normalize on id everywhere in manager.
      gallery = Gallery.unscoped.find( params[:gallery_id] )
      gallery ||= Gallery.unscoped.where( :slug => params[:gallery_id] ).first
    end
    authorize! :create_photo, gallery

    @photo = Photo.new params[:photo].permit!
    @photo.is_public = true
    @photo.gallery = gallery

    # cache
    @photo.gallery.site.touch if @photo.gallery.site
    @photo.gallery.city.touch if @photo.gallery.city
    @photo.gallery.touch

    if @photo.save
      j = {
        :name => @photo.photo.original_filename,
        :size => @photo.photo.size,
        :url => @photo.photo.url( :large ),
        :thumbnail_url => @photo.photo.url( :thumb ),
        :delete_url => photo_path(@photo),
        :delete_type => 'DELETE'
      }
      render :json => [ j ]
    else
      render :json => { "errors" => @photo.errors }
    end
  end

end

