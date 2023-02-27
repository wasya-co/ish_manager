
class ::IshManager::CategoriesController < IshManager::ApplicationController

  before_action :set_lists

  def index
    authorize! :categories_index, IshManager::Ability
    # @categories = Category.all_hierarchical
    @categories_flat = Category.all_flat
    @tags = Category.all_tags
  end

end

