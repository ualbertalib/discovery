# -*- encoding: utf-8 -*-
require File.expand_path('../lib/ensure_valid_encoding/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jonathan Rochkind"]
  gem.email         = ["jonathan@dnil.net"]
  gem.summary   = %q{For ruby 1.9 strings, replace bad bytes in given encoding with replacement strings, _or_ fail quickly on invalid encodings --  _without_ a transcode to a different encoding. 
}
  gem.homepage      = "https://github.com/jrochkind/ensure_valid_encoding"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "ensure_valid_encoding"
  gem.require_paths = ["lib"]
  gem.version       = EnsureValidEncoding::VERSION
end
