
class IshManager::ReportsController < IshManager::ApplicationController

  before_action :set_lists

  # alphabetized : )

  def create
    @report = Report.new params[:report].permit!
    @report.user_profile = current_user.profile # @TODO: this should not be hard-coded
    authorize! :create, @report

    flag = @report.save
    respond_to do |format|
      if flag

        ## @TODO: I'm sure there is a better way
        if params[:report][:photo]
          photo = Photo.new
          photo.photo = params[:report][:photo]
          photo.is_public = @report.is_public
          photo.is_trash = false
          photo.report_id = @report.id
          photo.save
        end

        format.html do
          redirect_to report_path(@report), :notice => 'Report was successfully created.'
        end
        format.json { render :json => @report, :status => :created, :location => @report } # TODO: remove, I got the api now.
      else
        format.html do
          flash[:alert] = @report.errors.full_messages
          @tags_list = Tag.all.list

          render :action => "new"
        end
        format.json { render :json => @report.errors, :status => :unprocessable_entity } # @TODO: remove, right? no api here.
      end
    end
  end

  def destroy
    @report = Report.unscoped.find params[:id]
    authorize! :destroy, @report
    @report.is_trash = true
    @report.save
    redirect_to request.referrer
  end

  def edit
    @report = Report.unscoped.find params[:id]
    authorize! :edit, @report
  end

  def index
    authorize! :index, Report
    @reports = Report.unscoped.order_by( :created_at => :desc
      ).where( :is_trash => false, :user_profile => current_user.profile
      ).page( params[:reports_page] ).per( Report::PER_PAGE )
    if params[:q]
      @reports = @reports.or({ slug: /#{params[:q]}/i }, { name: /#{params[:q]}}/i }) # @TODO: why can't I have space in search term?
      if @reports.length == 1
        redirect_to report_path(@reports[0])
        return
      end
    end
  end

  def new
    @report = Report.new
    authorize! :new, @report
    @tags_list = Tag.all.where( :is_public => true ).list

    respond_to do |format|
      format.html do
        render
      end
      format.json { render :json => @report }
    end
  end

  def show
    @report = Report.unscoped.find params[:id]
    authorize! :show, @report
  end

  def update
    @report = Report.unscoped.find params[:id]
    authorize! :update, @report

    if params[:photo]
      photo = Photo.new :photo => params[:photo]
      @report.update_attributes( :photo => photo, :updated_at => Time.now )
    end

    respond_to do |format|
      if @report.update_attributes(params[:report].permit!)
        format.html do
          redirect_to report_path(@report), :notice => 'Report was successfully updated.'
        end
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @report.errors, :status => :unprocessable_entity }
      end
    end
  end

end

