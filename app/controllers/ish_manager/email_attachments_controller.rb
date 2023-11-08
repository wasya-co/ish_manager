
class ::IshManager::EmailAttachmentsController < IshManager::ApplicationController

  def show
    att = Office::EmailAttachment.find params[:id]
    authorize! :show, att
    send_data(
      att.content,
      filename: att.filename || "this_download",
      type: att.content_type )
  end

end
