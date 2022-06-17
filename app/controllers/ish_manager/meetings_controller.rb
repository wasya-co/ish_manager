
class IshManager::MeetingsController < IshManager::ApplicationController

  layout 'ish_manager/application_no_material'

  # alphabetized

  def create
    authorize! :create, Ish::Meeting
    @meeting = Ish::Meeting.new meeting_params
    if @meeting.save
      if @meeting.send_reminder_morning
        y = @meeting.datetime.year
        m = @meeting.datetime.month
        d = @meeting.datetime.day
        h = 9
        m = 5 # 9:05am
        IshManager::MeetingMailer.morning_reminder( meeting_id: @meeting.id.to_s
        ).deliver_later({ wait_until: DateTime.new(y,m,d,h,m) })
      end
      if @meeting.send_reminder_15min
      end
      flash[:notice] = 'Meeting created'
      redirect_to action: 'index'
    else
      flash[:alert] = "Cannot create meeting: #{@meeting.errors.full_messages.join(", ")}."
      render 'new'
    end
  end

  def destroy
  end

  def edit
  end

  def index
    authorize! :index, Ish::Meeting
    @meetings = Ish::Meeting.all
  end

  def new
    @meeting = Ish::Meeting.new
    authorize! :new, @meeting
  end

  def update
  end

  private

  def meeting_params
    params.require(:meeting).permit!
  end

end
