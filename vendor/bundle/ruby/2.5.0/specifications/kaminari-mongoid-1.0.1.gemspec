# -*- encoding: utf-8 -*-
# stub: kaminari-mongoid 1.0.1 ruby lib

Gem::Specification.new do |s|
  s.name = "kaminari-mongoid".freeze
  s.version = "1.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Akira Matsuda".freeze]
  s.bindir = "exe".freeze
  s.date = "2017-01-25"
  s.description = "kaminari-mongoid lets your Mongoid models be paginatable".freeze
  s.email = ["ronnie@dio.jp".freeze]
  s.homepage = "https://github.com/kaminari/kaminari-mongoid".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.0.6".freeze
  s.summary = "Kaminari Mongoid adapter".freeze

  s.installed_by_version = "3.0.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<kaminari-core>.freeze, ["~> 1.0"])
      s.add_runtime_dependency(%q<mongoid>.freeze, [">= 0"])
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.9"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<rails>.freeze, [">= 0"])
      s.add_development_dependency(%q<test-unit-rails>.freeze, [">= 0"])
      s.add_development_dependency(%q<capybara>.freeze, [">= 0"])
      s.add_development_dependency(%q<rr>.freeze, [">= 0"])
      s.add_development_dependency(%q<byebug>.freeze, [">= 0"])
    else
      s.add_dependency(%q<kaminari-core>.freeze, ["~> 1.0"])
      s.add_dependency(%q<mongoid>.freeze, [">= 0"])
      s.add_dependency(%q<bundler>.freeze, ["~> 1.9"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<rails>.freeze, [">= 0"])
      s.add_dependency(%q<test-unit-rails>.freeze, [">= 0"])
      s.add_dependency(%q<capybara>.freeze, [">= 0"])
      s.add_dependency(%q<rr>.freeze, [">= 0"])
      s.add_dependency(%q<byebug>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<kaminari-core>.freeze, ["~> 1.0"])
    s.add_dependency(%q<mongoid>.freeze, [">= 0"])
    s.add_dependency(%q<bundler>.freeze, ["~> 1.9"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<rails>.freeze, [">= 0"])
    s.add_dependency(%q<test-unit-rails>.freeze, [">= 0"])
    s.add_dependency(%q<capybara>.freeze, [">= 0"])
    s.add_dependency(%q<rr>.freeze, [">= 0"])
    s.add_dependency(%q<byebug>.freeze, [">= 0"])
  end
end
