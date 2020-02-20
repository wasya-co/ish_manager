
class IshManager::IronCondorsController < IshManager::ApplicationController

  def index
    authorize! :index, ::Ish::IronCondor
    @condors = ::Ish::IronCondor.all
  end

  def create
    condor = ::Ish::IronCondor.new params[:ish_iron_condor].permit!
    authorize! :create, condor
    condor.ticker.upcase!
    if condor.save
      flash[:notice] = 'Success.'
    else
      flash[:alert] = condor.errors.messages.to_s
    end
    redirect_to action: :index
  end

  def update
    condor = ::Ish::IronCondor.find params[:id]
    authorize! :update, condor
    condor.update params[:ish_iron_condor].permit!
    condor.ticker.upcase!
    if condor.save
      flash[:notice] = 'Success.'
    else
      flash[:alert] = condor.errors.messages.to_s
    end
    redirect_to action: :index
  end

  def destroy
    condor = ::Ish::IronCondor.find params[:id]
    authorize! :destroy, condor
    if condor.destroy
      flash[:notice] = 'Success.'
    else
      flash[:alert] = condor.errors.messages.to_s
    end
    redirect_to action: :index
  end

end
