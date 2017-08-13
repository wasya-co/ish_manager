module IshManager
  module ApplicationHelper

    def pretty_date input
      return input.strftime("%Y-%m-%d")
    end

    def pp_errors errors
      return errors
    end

  end
end
