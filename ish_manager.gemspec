$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "ish_manager/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ish_manager"
  s.version     = '0.1.8.309'
  s.authors     = ["piousbox"]
  s.email       = ["piousbox@gmail.com"]
  s.homepage    = "http://wasya.co"
  s.summary     = "Summary of IshManager."
  s.description = "Description of IshManager."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_runtime_dependency 'aws-sdk'
  s.add_runtime_dependency "cancancan", [ "~> 2.0" ]
  s.add_runtime_dependency "devise", [ "~> 4.3" ]
  s.add_runtime_dependency 'ffi', '1.11.3'
  s.add_runtime_dependency "haml", [ '~> 5.0' ]
  s.add_runtime_dependency 'httparty'
  s.add_runtime_dependency "ish_models"
  s.add_runtime_dependency "kaminari-mongoid", [ "~> 1.0" ]
  s.add_runtime_dependency "kaminari-actionview", [ "~> 1.0" ]
  s.add_runtime_dependency "mongoid-autoinc", [ "~> 6.0" ]
  s.add_runtime_dependency 'mongoid-paperclip'
  s.add_runtime_dependency "rails", "~> 6.0.0" 
  s.add_runtime_dependency 'uglifier'
end
