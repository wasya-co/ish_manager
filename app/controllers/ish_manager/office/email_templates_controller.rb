
class ::IshManager::Office::EmailTemplatesController < ::IshManager::ApplicationController

  def index
    authorize! :index, Ish::Office::EmailTemplate
  end

  def show
    authorize! :show, Ish::Office::EmailTemplate
    render params[:id], layout: false
  end


end
