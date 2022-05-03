
class IshManager::MeetingMailer < IshManager::ApplicationMailer
  default from: 'piousbox@gmail.com'
  # layout 'mailer'

  def morning_reminder meeting_id:
    @meeting = Ish::Meeting.find meeting_id
    mail( to: @meeting.invitee_email,
          bcc: 'piousbox@gmail.com',
          subject: 'A reminder for your upcoming meeting' )
  end

end
