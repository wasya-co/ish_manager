
class ::IshManager::EmailConversationsController < IshManager::ApplicationController

  def index
    authorize! :email_conversations_index, IshManager::Ability
    @email_conversations = ::Office::EmailConversation.all.order_by( latest_date: :desc )

  end

  def show
    authorize! :email_conversations_show, IshManager::Ability
    @email_conversation = ::Office::EmailConversation.find( params[:id] )
    @email_messages = @email_conversation.email_messages.order_by( date: :desc )
  end

end
