# -*- encoding: utf-8 -*-
# stub: activerecord-session_store 0.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "activerecord-session_store"
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["David Heinemeier Hansson"]
  s.date = "2013-10-24"
  s.email = "david@loudthinking.com"
  s.extra_rdoc_files = ["README.md"]
  s.files = ["README.md"]
  s.homepage = "http://www.rubyonrails.org"
  s.licenses = ["MIT"]
  s.rdoc_options = ["--main", "README.md"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3")
  s.rubygems_version = "2.2.2"
  s.summary = "An Action Dispatch session store backed by an Active Record class."

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, ["< 5", ">= 4.0.0"])
      s.add_runtime_dependency(%q<actionpack>, ["< 5", ">= 4.0.0"])
      s.add_runtime_dependency(%q<railties>, ["< 5", ">= 4.0.0"])
      s.add_development_dependency(%q<sqlite3>, [">= 0"])
    else
      s.add_dependency(%q<activerecord>, ["< 5", ">= 4.0.0"])
      s.add_dependency(%q<actionpack>, ["< 5", ">= 4.0.0"])
      s.add_dependency(%q<railties>, ["< 5", ">= 4.0.0"])
      s.add_dependency(%q<sqlite3>, [">= 0"])
    end
  else
    s.add_dependency(%q<activerecord>, ["< 5", ">= 4.0.0"])
    s.add_dependency(%q<actionpack>, ["< 5", ">= 4.0.0"])
    s.add_dependency(%q<railties>, ["< 5", ">= 4.0.0"])
    s.add_dependency(%q<sqlite3>, [">= 0"])
  end
end
