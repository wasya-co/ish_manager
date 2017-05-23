module IshManager
  class ApplicationController < ActionController::Base
    protect_from_forgery :with => :exception

    before_action :set_lists

    def home
      authorize! :home, Manager
      render 'home'
    end

    private

    def set_lists
      @current_ability ||= ::IshManager::Ability.new( current_user )
    end

  end
end
