
class ::IshManager::EmailMessagesController < IshManager::ApplicationController

  def index
    authorize! :email_messages_index, IshManager::Ability
    @email_messages = Office::EmailMessage.all.order_by( date: :desc ).per( current_profile.per_page )
  end

  def show
    authorize! :email_messages_show, IshManager::Ability
    @email_message = Office::EmailMessage.find params[:id]
  end

  def show_iframe
    authorize! :email_messages_show, IshManager::Ability
    @email_message = Office::EmailMessage.find params[:id]
    render layout: 'ish_manager/email_iframe'
  end

  def show_source
    authorize! :email_messages_show, IshManager::Ability
    @email_message = Office::EmailMessage.find params[:id]
    render layout: false
  end

  def show_stripped
    authorize! :email_messages_show, IshManager::Ability
    @email_message = Office::EmailMessage.find params[:id]
    render layout: false
  end

end
