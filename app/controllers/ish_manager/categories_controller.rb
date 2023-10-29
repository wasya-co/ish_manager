
class ::IshManager::CategoriesController < IshManager::ApplicationController

  before_action :set_lists

  def index
    authorize! :categories_index, IshManager::Ability
    # @categories = Category.all_hierarchical
    @categories_flat = Category.all_flat
    @tags = Category.all_tags
  end

  def show
    @category = WpTag.find params[:id]
    authorize! :show, @category

    ## same as in leads#index
    @leads = @category.leads
    if params[:q].present?
      @leads = @leads.where(" email LIKE ? ", "%#{params[:q]}%" )
    end
    @leads = @leads.page( params[:leads_page] ).per( current_profile.per_page )
  end

  def create_email_tag
    @tag = WpTag.emailtag( params[:tag][:name] )
    authorize! :create, @tag
    @tag.persisted? ? flash_notice('persisted') : flash_alert('cannot save tag')
    redirect_to request.referrer ? request.referrer : email_conversations_path
  end

end

