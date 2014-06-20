# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "unf_ext"
  s.version = "0.0.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Takeru Ohta", "Akinori MUSHA"]
  s.date = "2013-02-16"
  s.description = "Unicode Normalization Form support library for CRuby"
  s.email = ["knu@idaemons.org"]
  s.extensions = ["ext/unf_ext/extconf.rb"]
  s.extra_rdoc_files = ["LICENSE.txt", "README.md"]
  s.files = ["LICENSE.txt", "README.md", "ext/unf_ext/extconf.rb"]
  s.homepage = "https://github.com/knu/ruby-unf_ext"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.3"
  s.summary = "Unicode Normalization Form support library for CRuby"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<rdoc>, ["> 2.4.2"])
      s.add_development_dependency(%q<bundler>, [">= 1.2"])
      s.add_development_dependency(%q<rake-compiler>, [">= 0.7.9"])
    else
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<rdoc>, ["> 2.4.2"])
      s.add_dependency(%q<bundler>, [">= 1.2"])
      s.add_dependency(%q<rake-compiler>, [">= 0.7.9"])
    end
  else
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<rdoc>, ["> 2.4.2"])
    s.add_dependency(%q<bundler>, [">= 1.2"])
    s.add_dependency(%q<rake-compiler>, [">= 0.7.9"])
  end
end
