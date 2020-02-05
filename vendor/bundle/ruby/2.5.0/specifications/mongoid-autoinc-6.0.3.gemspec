# -*- encoding: utf-8 -*-
# stub: mongoid-autoinc 6.0.3 ruby lib

Gem::Specification.new do |s|
  s.name = "mongoid-autoinc".freeze
  s.version = "6.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Robert Beekman".freeze, "Steven Weller".freeze, "Jacob Vosmaer".freeze]
  s.date = "2018-06-20"
  s.description = "Think auto incrementing field from SQL for mongoid.".freeze
  s.email = ["robert@80beans.com".freeze, "steven@80beans.com".freeze, "jacob@80beans.com".freeze]
  s.homepage = "https://github.com/suweller/mongoid-autoinc".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.0.6".freeze
  s.summary = "Add auto incrementing fields to mongoid documents".freeze

  s.installed_by_version = "3.0.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mongoid>.freeze, [">= 6.0", "< 8.0"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<foreman>.freeze, [">= 0"])
      s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
      s.add_development_dependency(%q<pry>.freeze, [">= 0"])
    else
      s.add_dependency(%q<mongoid>.freeze, [">= 6.0", "< 8.0"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<foreman>.freeze, [">= 0"])
      s.add_dependency(%q<rspec>.freeze, [">= 0"])
      s.add_dependency(%q<pry>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<mongoid>.freeze, [">= 6.0", "< 8.0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<foreman>.freeze, [">= 0"])
    s.add_dependency(%q<rspec>.freeze, [">= 0"])
    s.add_dependency(%q<pry>.freeze, [">= 0"])
  end
end
