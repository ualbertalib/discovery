# -*- encoding: utf-8 -*-
# stub: jettywrapper 1.8.1 ruby lib

Gem::Specification.new do |s|
  s.name = "jettywrapper"
  s.version = "1.8.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Chris Beer", "Justin Coyne", "Bess Sadler"]
  s.date = "2014-07-18"
  s.description = "Spin up a jetty instance (e.g., the one at https://github.com/projecthydra/hydra-jetty) and wrap test in it. This lets us run tests against a real copy of solr and fedora."
  s.email = ["hydra-tech@googlegroups.com"]
  s.homepage = "https://github.com/projecthydra/jettywrapper"
  s.rubygems_version = "2.2.2"
  s.summary = "Convenience tasks for working with jetty from within a ruby project."

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<logger>, [">= 0"])
      s.add_runtime_dependency(%q<childprocess>, [">= 0"])
      s.add_runtime_dependency(%q<i18n>, [">= 0"])
      s.add_runtime_dependency(%q<activesupport>, [">= 3.0.0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.99"])
      s.add_development_dependency(%q<rspec-its>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<yard>, [">= 0"])
    else
      s.add_dependency(%q<logger>, [">= 0"])
      s.add_dependency(%q<childprocess>, [">= 0"])
      s.add_dependency(%q<i18n>, [">= 0"])
      s.add_dependency(%q<activesupport>, [">= 3.0.0"])
      s.add_dependency(%q<rspec>, ["~> 2.99"])
      s.add_dependency(%q<rspec-its>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<yard>, [">= 0"])
    end
  else
    s.add_dependency(%q<logger>, [">= 0"])
    s.add_dependency(%q<childprocess>, [">= 0"])
    s.add_dependency(%q<i18n>, [">= 0"])
    s.add_dependency(%q<activesupport>, [">= 3.0.0"])
    s.add_dependency(%q<rspec>, ["~> 2.99"])
    s.add_dependency(%q<rspec-its>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<yard>, [">= 0"])
  end
end
