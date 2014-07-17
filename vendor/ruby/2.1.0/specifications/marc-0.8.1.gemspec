# -*- encoding: utf-8 -*-
# stub: marc 0.8.1 ruby lib

Gem::Specification.new do |s|
  s.name = "marc"
  s.version = "0.8.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Kevin Clarke", "Bill Dueber", "William Groppe", "Jonathan Rochkind", "Ross Singer", "Ed Summers"]
  s.autorequire = "marc"
  s.date = "2013-11-26"
  s.email = "ehs@pobox.com"
  s.homepage = "https://github.com/ruby-marc/ruby-marc/"
  s.licenses = ["MIT"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.6")
  s.rubygems_version = "2.2.2"
  s.summary = "A ruby library for working with Machine Readable Cataloging"

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<ensure_valid_encoding>, [">= 0"])
      s.add_runtime_dependency(%q<unf>, [">= 0"])
    else
      s.add_dependency(%q<ensure_valid_encoding>, [">= 0"])
      s.add_dependency(%q<unf>, [">= 0"])
    end
  else
    s.add_dependency(%q<ensure_valid_encoding>, [">= 0"])
    s.add_dependency(%q<unf>, [">= 0"])
  end
end
