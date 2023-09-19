
class ::IshManager::EmailConversationsController < IshManager::ApplicationController

  before_action :set_lists

  def index
    authorize! :email_conversations_index, IshManager::Ability
    @email_conversations = ::Office::EmailConversation.all

    if current_profile.per_page > 100
      flash_notice "Cannot display more than 100 conversations per page."
      per_page = 100
    else
      per_page = current_profile.per_page
    end

    if params[:slug]
      @email_conversations = @email_conversations.in_emailtag( params[:slug] )
    end
    if params[:not_slug]
      @email_conversations = @email_conversations.not_in_emailtag(params[:not_slug])
    end
    @email_conversations = @email_conversations.order_by( latest_at: :desc
      ).page( params[:conv_page]
      ).per( per_page )
  end


  def show
    authorize! :email_conversations_show, IshManager::Ability
    @email_conversation = ::Office::EmailConversation.find( params[:id] )
    @email_messages = @email_conversation.email_messages.order_by( date: :asc )
    @email_conversation.update_attributes({ state: Conv::STATE_READ })
  end

end
