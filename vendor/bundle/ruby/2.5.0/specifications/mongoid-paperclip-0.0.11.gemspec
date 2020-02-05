# -*- encoding: utf-8 -*-
# stub: mongoid-paperclip 0.0.11 ruby lib

Gem::Specification.new do |s|
  s.name = "mongoid-paperclip".freeze
  s.version = "0.0.11"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Michael van Rooijen".freeze]
  s.date = "2016-08-10"
  s.description = "Enables you to use Paperclip with the Mongoid ODM for MongoDB.".freeze
  s.email = "michael@vanrooijen.io".freeze
  s.homepage = "https://github.com/meskyanichi/mongoid-paperclip".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.0.6".freeze
  s.summary = "Paperclip compatibility for Mongoid ODM for MongoDB.".freeze

  s.installed_by_version = "3.0.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mongoid>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<paperclip>.freeze, [">= 2.3.6", "!= 4.3.0"])
      s.add_development_dependency(%q<bundler>.freeze, [">= 0"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
    else
      s.add_dependency(%q<mongoid>.freeze, [">= 0"])
      s.add_dependency(%q<paperclip>.freeze, [">= 2.3.6", "!= 4.3.0"])
      s.add_dependency(%q<bundler>.freeze, [">= 0"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<rspec>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<mongoid>.freeze, [">= 0"])
    s.add_dependency(%q<paperclip>.freeze, [">= 2.3.6", "!= 4.3.0"])
    s.add_dependency(%q<bundler>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<rspec>.freeze, [">= 0"])
  end
end
