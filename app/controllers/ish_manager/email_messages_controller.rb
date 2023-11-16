
class ::IshManager::EmailMessagesController < IshManager::ApplicationController

  ## with object_key, invoking EIJ
  def create
    authorize! :create, Office::EmailMessage

    object_key = params[:msg][:object_key]
    MsgStub.where({ object_key: object_key }).delete

    stub = MsgStub.create({ object_key: object_key })
    if !stub.persisted?
      flash_alert "Stub could not be persisted: #{stub.errors.full_messages.join(', ')} ."
      redirect_to request.referrer
      return
    end

    Rails.env.production? ? EIJ.perform_later( stub.id.to_s ) : EIJ.perform_now( stub.id.to_s )

    flash_notice "Re-inited proc'ing object_key #{object_key} ."
    redirect_to request.referrer
  end

  def index
    authorize! :email_messages_index, IshManager::Ability
    redirect_to controller: :email_conversations, action: :index
    # @email_messages = Office::EmailMessage.all.order_by( date: :desc )
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
