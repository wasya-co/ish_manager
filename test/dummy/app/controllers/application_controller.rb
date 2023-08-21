class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def home
    if current_user
      redirect_to ish_manager_path
    else
      redirect_to new_user_session_path
    end
  end

  private

  def set_current_ability
    @current_ability ||= ::IshManager::Ability.new( @current_profile )
  end

end
