
class Manager::ReportsController < Manager::ManagerController

  before_action :authenticate_user!
  before_filter :set_lists

  def index
    @reports = Report.unscoped.where( :is_trash => false ).page( params[:reports_page] ).per( Report::PER_PAGE )
    if false === params[:site]
      @reports = @reports.where( :site_id => nil )
    end
    if params[:site_id]
      @site = Site.find params[:site_id]
      @reports = @reports.where( :site_id => params[:site_id] )
    end
  end

  def show
    @report = Report.unscoped.where({ :is_trash => false }).find params[:id]
  end

  def edit
    @report = Report.unscoped.find params[:id]
  end

  def destroy
    @report = Report.unscoped.find params[:id]
    @report.is_trash = true
    @report.save
    redirect_to request.referrer
  end

  def update
    @report = Report.unscoped.find params[:id]
    authorize! :update, @report

    # photo
    photo = Photo.new
    photo.photo = params[:report][:photo]
    photo.report_id = @report.id
    photo.user = @report.user
    photo.is_public = @report.is_public
    photo.is_trash = false
    photo.save
    @report.photo = photo
    params[:report][:photo] = nil

    respond_to do |format|
      if @report.update_attributes(params[:report].permit( :name, :subhead, :descr, :venue, :city, :x, :y, :tag, :is_public, :photo, :site, :site_id ))
        format.html do
          redirect_to manager_report_path(@report), :notice => 'Report was successfully updated.'
        end
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @report.errors, :status => :unprocessable_entity }
      end
    end
  end

end

