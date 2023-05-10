
class IshManager::ImageAssetsController < IshManager::ApplicationController

  def index
    authorize! :index, Ish::ImageAsset
    @image_assets = Ish::ImageAsset.all.order_by( created_at: :desc ).per( current_profile.per_page )
  end

end

