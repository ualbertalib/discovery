# -*- encoding: utf-8 -*-
# stub: rsolr 1.0.10 ruby lib

Gem::Specification.new do |s|
  s.name = "rsolr"
  s.version = "1.0.10"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Antoine Latter", "Dmitry Lihachev", "Lucas Souza", "Peter Kieltyka", "Rob Di Marco", "Magnus Bergmark", "Jonathan Rochkind", "Chris Beer", "Craig Smith", "Randy Souza", "Colin Steele", "Peter Kieltyka", "Lorenzo Riccucci", "Mike Perham", "Mat Brown", "Shairon Toledo", "Matthew Rudy", "Fouad Mardini", "Jeremy Hinegardner", "Nathan Witmer", "\"shima\""]
  s.date = "2014-03-26"
  s.description = "RSolr aims to provide a simple and extensible library for working with Solr"
  s.email = ["goodieboy@gmail.com"]
  s.homepage = "https://github.com/mwmitchell/rsolr"
  s.rubyforge_project = "rsolr"
  s.rubygems_version = "2.4.1"
  s.summary = "A Ruby client for Apache Solr"

  s.installed_by_version = "2.4.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<builder>, [">= 2.1.2"])
      s.add_development_dependency(%q<activesupport>, [">= 0"])
      s.add_development_dependency(%q<nokogiri>, [">= 1.4.0"])
      s.add_development_dependency(%q<rake>, ["~> 0.9.2"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.9.4"])
      s.add_development_dependency(%q<rspec>, ["~> 2.6.0"])
    else
      s.add_dependency(%q<builder>, [">= 2.1.2"])
      s.add_dependency(%q<activesupport>, [">= 0"])
      s.add_dependency(%q<nokogiri>, [">= 1.4.0"])
      s.add_dependency(%q<rake>, ["~> 0.9.2"])
      s.add_dependency(%q<rdoc>, ["~> 3.9.4"])
      s.add_dependency(%q<rspec>, ["~> 2.6.0"])
    end
  else
    s.add_dependency(%q<builder>, [">= 2.1.2"])
    s.add_dependency(%q<activesupport>, [">= 0"])
    s.add_dependency(%q<nokogiri>, [">= 1.4.0"])
    s.add_dependency(%q<rake>, ["~> 0.9.2"])
    s.add_dependency(%q<rdoc>, ["~> 3.9.4"])
    s.add_dependency(%q<rspec>, ["~> 2.6.0"])
  end
end
