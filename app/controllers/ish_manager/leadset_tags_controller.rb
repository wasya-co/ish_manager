
class IshManager::LeadsetTagsController < IshManager::ApplicationController

  ## params[ :leadset_id, :term_id, ]
  def create
    authorize! :leadset_tags_create, ::IshManager

    lt = LeadsetTag.new( leadset_id: params[:leadset_id], term_id: params[:term_id] )
    flag = lt.save
    if flag
      flash[:notice] = 'Success'
    else
      flash[:alert] = "No luck: #{lt.errors.full_messages.join(', ')}"
    end
    redirect_to request.referrer ? request.referrer : leadsets_path
  end

end
