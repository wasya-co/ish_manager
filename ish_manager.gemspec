$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "ish_manager/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ish_manager"
  s.version     = '0.1.8.284'
  s.authors     = ["piousbox"]
  s.email       = ["piousbox@gmail.com"]
  s.homepage    = "http://wasya.co"
  s.summary     = "Summary of IshManager."
  s.description = "Description of IshManager."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "activeadmin", [ "~> 1.0" ] # @TODO: I don't even use it
  s.add_dependency 'aws-sdk'
  s.add_dependency "cancancan", [ "~> 2.0" ]
  s.add_dependency "devise", [ "~> 4.3" ]
  s.add_dependency 'ffi', '1.11.3'
  s.add_dependency "haml", [ '~> 5.0' ]
  s.add_dependency 'httparty'
  s.add_dependency "ish_models"
  s.add_dependency "kaminari-mongoid", [ "~> 1.0" ]
  s.add_dependency "kaminari-actionview", [ "~> 1.0" ]
  s.add_dependency "mongoid-autoinc", [ "~> 6.0" ]
  s.add_dependency 'mongoid-paperclip'
  s.add_dependency "rails", [ "~> 5.1" ]
  s.add_dependency 'uglifier'
end
