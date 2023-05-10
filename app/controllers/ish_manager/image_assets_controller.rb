
##
## trash?! _vp_ 2023-05-10
##
class IshManager::ImageAssetsController < IshManager::ApplicationController

  def index
    authorize! :index, Ish::ImageAsset
    @image_assets = Ish::ImageAsset.all.order_by( created_at: :desc )
  end

end

