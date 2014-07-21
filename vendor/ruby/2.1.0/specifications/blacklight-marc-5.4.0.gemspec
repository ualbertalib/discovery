# -*- encoding: utf-8 -*-
# stub: blacklight-marc 5.4.0 ruby lib

Gem::Specification.new do |s|
  s.name = "blacklight-marc"
  s.version = "5.4.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Justin Coyne"]
  s.date = "2014-05-06"
  s.description = "MARC support for Blacklight"
  s.email = ["justin@curationexperts.com"]
  s.homepage = "https://github.com/projectblacklight/blacklight_marc"
  s.licenses = ["Apache 2.0"]
  s.rubygems_version = "2.2.2"
  s.summary = "MARC support for Blacklight"

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<blacklight>, ["< 6.0", ">= 5.4.0.rc1"])
      s.add_development_dependency(%q<bundler>, ["~> 1.3"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<rspec-rails>, [">= 0"])
      s.add_development_dependency(%q<jettywrapper>, [">= 0"])
      s.add_development_dependency(%q<capybara>, [">= 0"])
      s.add_runtime_dependency(%q<rails>, [">= 0"])
      s.add_runtime_dependency(%q<marc>, ["< 1.1", ">= 0.4.3"])
    else
      s.add_dependency(%q<blacklight>, ["< 6.0", ">= 5.4.0.rc1"])
      s.add_dependency(%q<bundler>, ["~> 1.3"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<rspec-rails>, [">= 0"])
      s.add_dependency(%q<jettywrapper>, [">= 0"])
      s.add_dependency(%q<capybara>, [">= 0"])
      s.add_dependency(%q<rails>, [">= 0"])
      s.add_dependency(%q<marc>, ["< 1.1", ">= 0.4.3"])
    end
  else
    s.add_dependency(%q<blacklight>, ["< 6.0", ">= 5.4.0.rc1"])
    s.add_dependency(%q<bundler>, ["~> 1.3"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<rspec-rails>, [">= 0"])
    s.add_dependency(%q<jettywrapper>, [">= 0"])
    s.add_dependency(%q<capybara>, [">= 0"])
    s.add_dependency(%q<rails>, [">= 0"])
    s.add_dependency(%q<marc>, ["< 1.1", ">= 0.4.3"])
  end
end
