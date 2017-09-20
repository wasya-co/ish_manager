module IshManager
  module ApplicationHelper

    def pretty_date input
      return input.strftime("%Y-%m-%d")
    end

    def pp_errors errors
      return errors
    end

    def user_path user
      if user.class == 'String'
        "/users/#{user}"
      elsif user.class == User
        "/users/#{user.id}"
      elsif user.class == NilClass
        "/users"
      end
    end

  end
end
