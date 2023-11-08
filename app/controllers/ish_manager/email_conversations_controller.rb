
class ::IshManager::EmailConversationsController < IshManager::ApplicationController

  before_action :set_lists, except: [ :index ]

  def index
    authorize! :email_conversations_index, IshManager::Ability
    @email_conversations = ::Office::EmailConversation.all

    @new_tag = WpTag.new
    @emailtags = WpTag.emailtags
    @emailtags_list = [[nil,nil]] + WpTag.emailtags.map { |p| [ p.name, p.slug ] }

    per_page = current_profile.per_page
    # if current_profile.per_page > 100
    #   flash_notice "Cannot display more than 100 conversations per page."
    #   per_page = 100
    # end

    if params[:slug]
      @email_conversations = @email_conversations.in_emailtag( params[:slug] )
    end

    if params[:not_slug]
      @email_conversations = @email_conversations.not_in_emailtag( params[:not_slug] )
    end

    if params[:subject].present?
      @email_conversations = @email_conversations.where({ subject: /.*#{params[:subject]}.*/i })
    end

    if params[:from_email].present?
      @email_conversations = @email_conversations.where({ from_emails: /.*#{params[:from_email]}.*/i })
    end

    @email_conversations = @email_conversations.order_by( latest_at: :desc
      ).includes( :email_messages # , :lead_ties
      ).page( params[:conv_page]
      ).per( per_page )
  end


  def show
    authorize! :email_conversations_show, IshManager::Ability
    @email_conversation = ::Office::EmailConversation.find( params[:id] )
    @email_messages     = @email_conversation.email_messages.order_by( date: :asc )
    @email_conversation.update_attributes({ state: Conv::STATE_READ })
  end

end
