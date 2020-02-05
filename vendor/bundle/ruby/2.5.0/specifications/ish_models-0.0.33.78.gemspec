# -*- encoding: utf-8 -*-
# stub: ish_models 0.0.33.78 ruby lib

Gem::Specification.new do |s|
  s.name = "ish_models".freeze
  s.version = "0.0.33.78"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["piousbox".freeze]
  s.date = "2017-05-10"
  s.description = "models of ish".freeze
  s.email = "victor@wasya.co".freeze
  s.homepage = "http://wasya.co".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.0.6".freeze
  s.summary = "models of ish".freeze

  s.installed_by_version = "3.0.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mongoid>.freeze, ["~> 6.1.0", ">= 6.1.0"])
      s.add_runtime_dependency(%q<mongoid-autoinc>.freeze, ["~> 6.0"])
      s.add_runtime_dependency(%q<mongoid-paperclip>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<kaminari-mongoid>.freeze, ["~> 1.0.1"])
      s.add_runtime_dependency(%q<devise>.freeze, ["> 0"])
      s.add_runtime_dependency(%q<aws-sdk>.freeze, [">= 0"])
    else
      s.add_dependency(%q<mongoid>.freeze, ["~> 6.1.0", ">= 6.1.0"])
      s.add_dependency(%q<mongoid-autoinc>.freeze, ["~> 6.0"])
      s.add_dependency(%q<mongoid-paperclip>.freeze, [">= 0"])
      s.add_dependency(%q<kaminari-mongoid>.freeze, ["~> 1.0.1"])
      s.add_dependency(%q<devise>.freeze, ["> 0"])
      s.add_dependency(%q<aws-sdk>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<mongoid>.freeze, ["~> 6.1.0", ">= 6.1.0"])
    s.add_dependency(%q<mongoid-autoinc>.freeze, ["~> 6.0"])
    s.add_dependency(%q<mongoid-paperclip>.freeze, [">= 0"])
    s.add_dependency(%q<kaminari-mongoid>.freeze, ["~> 1.0.1"])
    s.add_dependency(%q<devise>.freeze, ["> 0"])
    s.add_dependency(%q<aws-sdk>.freeze, [">= 0"])
  end
end
