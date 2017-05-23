module IshManager
  class ApplicationController < ActionController::Base
    protect_from_forgery :with => :exception

    before_action :set_current_ability

    def home
      authorize! :home, Manager
      render 'home'
    end

    private

    def set_current_ability
      @current_ability ||= ::IshManager::Ability.new( current_user )
    end

  end
end
