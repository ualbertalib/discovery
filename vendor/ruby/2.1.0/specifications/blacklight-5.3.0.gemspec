# -*- encoding: utf-8 -*-
# stub: blacklight 5.3.0 ruby lib

Gem::Specification.new do |s|
  s.name = "blacklight"
  s.version = "5.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Jonathan Rochkind", "Matt Mitchell", "Chris Beer", "Jessie Keck", "Jason Ronallo", "Vernon Chapman", "Mark A. Matienzo", "Dan Funk", "Naomi Dushay", "Justin Coyne"]
  s.date = "2014-03-20"
  s.description = "Blacklight is an open source Solr user interface discovery platform. You can use Blacklight to enable searching and browsing of your collections. Blacklight uses the Apache Solr search engine to search full text and/or metadata."
  s.email = ["blacklight-development@googlegroups.com"]
  s.homepage = "http://projectblacklight.org/"
  s.licenses = ["Apache 2.0"]
  s.rubygems_version = "2.2.2"
  s.summary = "Blacklight provides a discovery interface for any Solr (http://lucene.apache.org/solr) index."

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, ["< 5", ">= 3.2.6"])
      s.add_runtime_dependency(%q<nokogiri>, ["~> 1.6"])
      s.add_runtime_dependency(%q<kaminari>, ["~> 0.13"])
      s.add_runtime_dependency(%q<rsolr>, ["~> 1.0.6"])
      s.add_runtime_dependency(%q<bootstrap-sass>, ["~> 3.0"])
      s.add_runtime_dependency(%q<deprecation>, [">= 0"])
      s.add_development_dependency(%q<jettywrapper>, [">= 1.7.0"])
      s.add_development_dependency(%q<blacklight-marc>, ["~> 5.0"])
      s.add_development_dependency(%q<rspec-rails>, [">= 0"])
      s.add_development_dependency(%q<capybara>, [">= 0"])
      s.add_development_dependency(%q<poltergeist>, [">= 0"])
      s.add_development_dependency(%q<engine_cart>, [">= 0.1.0"])
      s.add_development_dependency(%q<equivalent-xml>, [">= 0"])
    else
      s.add_dependency(%q<rails>, ["< 5", ">= 3.2.6"])
      s.add_dependency(%q<nokogiri>, ["~> 1.6"])
      s.add_dependency(%q<kaminari>, ["~> 0.13"])
      s.add_dependency(%q<rsolr>, ["~> 1.0.6"])
      s.add_dependency(%q<bootstrap-sass>, ["~> 3.0"])
      s.add_dependency(%q<deprecation>, [">= 0"])
      s.add_dependency(%q<jettywrapper>, [">= 1.7.0"])
      s.add_dependency(%q<blacklight-marc>, ["~> 5.0"])
      s.add_dependency(%q<rspec-rails>, [">= 0"])
      s.add_dependency(%q<capybara>, [">= 0"])
      s.add_dependency(%q<poltergeist>, [">= 0"])
      s.add_dependency(%q<engine_cart>, [">= 0.1.0"])
      s.add_dependency(%q<equivalent-xml>, [">= 0"])
    end
  else
    s.add_dependency(%q<rails>, ["< 5", ">= 3.2.6"])
    s.add_dependency(%q<nokogiri>, ["~> 1.6"])
    s.add_dependency(%q<kaminari>, ["~> 0.13"])
    s.add_dependency(%q<rsolr>, ["~> 1.0.6"])
    s.add_dependency(%q<bootstrap-sass>, ["~> 3.0"])
    s.add_dependency(%q<deprecation>, [">= 0"])
    s.add_dependency(%q<jettywrapper>, [">= 1.7.0"])
    s.add_dependency(%q<blacklight-marc>, ["~> 5.0"])
    s.add_dependency(%q<rspec-rails>, [">= 0"])
    s.add_dependency(%q<capybara>, [">= 0"])
    s.add_dependency(%q<poltergeist>, [">= 0"])
    s.add_dependency(%q<engine_cart>, [">= 0.1.0"])
    s.add_dependency(%q<equivalent-xml>, [">= 0"])
  end
end
