# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "ensure_valid_encoding"
  s.version = "0.5.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jonathan Rochkind"]
  s.date = "2012-12-06"
  s.email = ["jonathan@dnil.net"]
  s.homepage = "https://github.com/jrochkind/ensure_valid_encoding"
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.3"
  s.summary = "For ruby 1.9 strings, replace bad bytes in given encoding with replacement strings, _or_ fail quickly on invalid encodings --  _without_ a transcode to a different encoding."
end
