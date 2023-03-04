
class ::IshManager::EmailFiltersController < ::IshManager::ApplicationController

  # before_action :set_lists

  # alphabetized : )

  def index
    authorize! :index, Office::EmailFilter.new
  end

end

