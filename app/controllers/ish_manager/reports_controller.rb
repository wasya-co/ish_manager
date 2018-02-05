
class IshManager::ReportsController < IshManager::ApplicationController

  before_action :set_lists

  def index
    authorize! :index, Report
    @reports = Report.unscoped.order_by( :created_at => :desc 
                                       ).where( :is_trash => false, :user_profile => current_user.profile
                                              ).page( params[:reports_page] 
                                                    ).per( Report::PER_PAGE )
    if false === params[:site]
      @reports = @reports.where( :site_id => nil )
    end
    if params[:site_id]
      @site = Site.find params[:site_id]
      @reports = @reports.where( :site_id => params[:site_id] )
    end
  end

  def show
    @report = Report.unscoped.find params[:id]
    authorize! :show, @report
  end

  def edit
    @report = Report.unscoped.find params[:id]
    authorize! :edit, @report
  end

  def destroy
    @report = Report.unscoped.find params[:id]
    authorize! :destroy, @report
    @report.is_trash = true
    @report.save
    redirect_to request.referrer
  end

  def update
    @report = Report.unscoped.find params[:id]
    authorize! :update, @report

    if params[:photo]
      photo = Photo.new :photo => params[:photo]
      @report.photo = photo
      @report.save
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

  def new
    @report = Report.new
    authorize! :new, @report
    @tags_list = Tag.all.where( :is_public => true ).list
    @sites_list = Site.all.list
    @cities_list = City.all.list
    @venues_list = Venue.all.list

    respond_to do |format|
      format.html do
        render
      end
      format.json { render :json => @report }
    end
  end

  def create
    @report = Report.new params[:report].permit!
    @report.user_profile = current_user.profile
    authorize! :create, @report

    @site = Site.where( :id => params[:report][:site_id] ).first
    @site ||= Site.find_by :domain => 'piousbox.com', :lang => :en 

    if @site
      redirect_path = site_reports_path( @site.id )
    end
    if params[:report][:city_id]
      redirect_path = city_path( params[:report][:city_id] )
    end

    # @report.user = @current_user || User.where( :username => 'anon' ).first
    # @report.username = @report.user.username
    @report[:lang] = @locale
    @report.name_seo ||= @report.id
    @report.is_feature = false
    @report.site = @site

    saved = false
    verified = true # verify_recaptcha( :model => @report, :message => 'There is a problem with recaptcha.' ) # @TODO: what this
    if Rails.env.development?
      verified = true
    end

    if verified
      saved = @report.save
    end

    respond_to do |format|
      if saved

        # photo
        photo = Photo.new 
        photo.photo = params[:report][:photo]
        # photo.user = @report.user
        photo.is_public = @report.is_public
        photo.is_trash = false
        photo.report_id = @report.id
        photo.save

        # for homepage
        # @TODO: move this to the model
        if @report.is_public
          n = Newsitem.new
          n.report = @report
          n.descr = @report.subhead
          # n.user = @report.user
          @site.newsitems << n
          @site.touch
          if @site.save
          else
            flash[:alert] = (flash[:alert]||'') + 'City could not be saved (newsitem). '
          end
        end

        format.html do
          redirect_to redirect_path, :notice => 'Report was successfully created (but newsitem, no information).' 
        end
        format.json { render :json => @report, :status => :created, :location => @report }
      else
        format.html do
          flash[:alert] = @report.errors.inspect
          @tags_list = Tag.all.where( :is_public => true ).list
          @sites_list = Site.all.list
          @cities_list = City.all.list

          render :action => "new"
        end
        format.json { render :json => @report.errors, :status => :unprocessable_entity }
      end
    end
  end

end

