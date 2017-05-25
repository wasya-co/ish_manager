module IshManager
  class Engine < ::Rails::Engine
    isolate_namespace IshManager
    initializer "blorgh.assets.precompile" do |app|
      app.config.assets.precompile += %w( application.js application.css )
    end
  end
end
