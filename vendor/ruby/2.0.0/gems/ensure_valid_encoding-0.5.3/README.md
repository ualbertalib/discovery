# EnsureValidEncoding

For ruby 1.9 strings, replace bad bytes in given encoding with replacement strings, _or_ fail quickly on invalid encodings --  _without_ a transcode to a different encoding. 

## Installation

Add this line to your application's Gemfile:

    gem 'ensure_valid_encoding'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ensure_valid_encoding

## Usage

~~~ruby
# \xE9 is not valid UTF-8
bad_utf8 = "M\xE9xico".force_encoding("UTF-8")  

EnsureValidEncoding.ensure_valid_encoding(bad_utf8)
# => raises a Encoding::InvalidByteSequenceError
#    Note well, sadly, for performance and pain-in-the-neck reasons,
#    this will not be filled out with byte number, preceeding or succeeding
#    bytes, or any other metadata normally included with an InvalidByteSequenceError
#    from stdlib. 
~~~~

Uses the same options as String#encode, `:invalid => :replace`, possibly
combined with `:replace => custom_replace_string` (which can be empty
string if you like). 

~~~ruby
fixed = EnsureValidEncoding.ensure_valid_encoding(bad_utf8, :invalid => :replace)
# => Replaces invalid bytes with default replacement char. 
#    For unicode encodings, that's unicode replacement code, "\uFFFD",
#    otherwise, '?'

fixed = EnsureValidEncoding.ensure_valid_encoding(bad_utf8, :invalid => :replace, :replace => "*")
# => "M*xico"
~~~

Mutate a string in-place with replacement chars? No problem, use the bang
version. 

~~~ruby
EnsureValidEncoding.ensure_valid_encoding!(bad_utf8, :invalid => :replace)
# bad_utf8 has been mutated
~~~

For convenience to save you some typing, methods defined as module instance
methods too:

~~~ruby
include EnsureValidEncoding
fixed = ensure_valid_encoding(bad_str)
~~~

## Rationale

You are taking textual input from some external source. Could be user input, 
could be a user-uploaded file of some kind, could be anchient usenet archives,
could be a a third party API response or web scrape, could be anything. 

You know what character encoding the textual data _claims_ to be, what it
_should_ be, and what it _usually_ is.  But occasionally it may have bad bytes
in it, due to data corruption, due to mistakes, due to mis-advertised encoding, 
due to bugs upstream, due to anything. 

What do you do?  If you do nothing, in cases of such corruption, then 
eventually your code will _probably_ (but not neccesarily) do something 
that causes some kind of exception to be raised, could be an 
Encoding::InvalidByteSequenceError, could be something else from somewhere else. 
May be hard to predict exactly when, if, and what will be raised. 
But when it does happen, if you're not rescue'ing the exception, 
your application dies hard. 

Okay, so maybe you manage to catch the exceptions. Or more 
conveniently you guard by testing `input_str.valid_encoding?` instead of waiting
for an exception to be raised. Then what? You could ignore this particular 
file/stream of input, and have your application go on it's merry way. 

But what if you want to do what most _every other_ mature application that
displays textual streams does in the case of bad bytes? Display the parts of the
string that _can_ be displayed, replace the other parts with a replacement
string of some sort. 

String#encode gives you an API for using a replacement char when converting/transcoding
from one encoding to another, but that's not where we are. We know what encoding
the string is supposed to be, we don't know any other better encoding to 
transcode it to -- we just want to do the best we can with it, substituting
any illegal bytes. It's what `bash` does. It's what `vim` does.  It is
surprisingly tricky to do with the ruby 1.9.3 stdlib, or even with 'iconv'. 

So there you go, now you can do it with this gem. Maybe not as performant 
as if it were implemented in C like stdlib char encoding routines, but, hey. 

 
**Note:** I have [filed a feature request](https://bugs.ruby-lang.org/issues/6321) for ruby stdlib. Developer from 
ruby core team also thinks it's an unusually odd thing to do. Most of rubydom seems to agree. Ce la vie. Me and
many of my colleagues need to do this all the time, but if you don't, don't do it. 

## Developing/Contributing

Some tests written with minitest/spec. Run with `rake test`. 

Gem built with bundler rake tests. `rake build`, `rake install`, `rake release`. 

Suggestions/improvements welcome. 

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
