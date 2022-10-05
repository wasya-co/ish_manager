class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def home
  end

  private

  def set_current_ability
    @current_ability ||= ::IshManager::Ability.new( @current_profile )
  end

end
