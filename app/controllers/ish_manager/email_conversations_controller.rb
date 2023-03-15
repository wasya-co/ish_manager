
class ::IshManager::EmailConversationsController < IshManager::ApplicationController

  layout 'ish_manager/application_fullwidth'

  before_action :set_lists

  def index
    authorize! :email_conversations_index, IshManager::Ability
    @email_conversations = ::Office::EmailConversation.all.order_by( latest_at: :desc )
  end

  def show
    authorize! :email_conversations_show, IshManager::Ability
    @email_conversation = ::Office::EmailConversation.find( params[:id] )
    @email_messages = @email_conversation.email_messages.order_by( date: :asc )
    @email_conversation.update_attributes({ state: Conv::STATE_READ })
  end

end
