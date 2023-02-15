
class ::IshManager::EmailMessagesController < IshManager::ApplicationController

  def index
    authorize! :index, Ish::EmailCampaign # @TODO: change!
    @email_messages = Office::EmailMessage.all
  end

  def show
    authorize! :index, Ish::EmailCampaign # @TODO: change!
    @email_message = Office::EmailMessage.find params[:id]
  end

end
