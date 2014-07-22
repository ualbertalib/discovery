# -*- encoding: utf-8 -*-
# stub: htmlentities 4.3.2 ruby lib

Gem::Specification.new do |s|
  s.name = "htmlentities"
  s.version = "4.3.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Paul Battley"]
  s.date = "2014-05-30"
  s.description = "A module for encoding and decoding (X)HTML entities."
  s.email = "pbattley@gmail.com"
  s.extra_rdoc_files = ["History.txt", "COPYING.txt"]
  s.files = ["COPYING.txt", "History.txt"]
  s.homepage = "https://github.com/threedaymonk/htmlentities"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.2.2"
  s.summary = "Encode/decode HTML entities"

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
