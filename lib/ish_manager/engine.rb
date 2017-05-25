module IshManager
  class Engine < ::Rails::Engine
    isolate_namespace IshManager

=begin
    initializer :assets do |config|
      # Rails.application.config.assets.precompile += %w{ ish_manager/application.js ish_manager/application.css application.js application.css }
      # Rails.application.config.assets.paths << root.join("ish_manager", "app", "assets", "images")
    end
=end

    initializer "ish_manager.assets.precompile" do |app|
      app.config.assets.precompile += %w( ish_manager/application.js ish_manager/application.css )
    end
  end
end
