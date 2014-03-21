require "ensure_valid_encoding/version"

module EnsureValidEncoding
  
  # Pass in a string, this method promises the return string
  # will be #valid_encoding? for the input's existing #encoding, or an exception
  # will be raised. 
  #
  # With no arguments, an Encoding::InvalidByteSequenceError will be raised
  # unless str.valid_encoding?  Unfortunately, unlike InvalidByteSequenceErrors
  # raised by stdlib, there will be _no_ line number or preceeding/succeeding
  # char info included in the exception though, sorry. 
  #
  # Or, just like String#encode, pass in :invalid => :replace to replace
  # invalid bytes with a replacement string. 
  #
  # Just like String#encode, the default replacement string is Unicode
  # replacement char for Unicode encodings or ascii "?" otherwise. 
  #
  # Just like String#encode, you can set your own replacement string (including
  # the empty string) with `:replace => your_string`
  #
  # Under ruby 1.8.x (or any ruby without String#encoding), 
  # this method no-ops and just returns it's input.
  #
  #     EnsureValidEncoding.ensure_valid_encoding( some_string )
  #
  #     include EnsureValidEncoding  
  #     ensure_valid_encoding( some_string, :invalid => :replace)
  #     ensure_valid_encoding( some_string, :invalid => :replace, :replace => '')
  #     ensure_valid_encoding( some_string, :invalid => :replace, :replace => "*")
    def self.ensure_valid_encoding(str, options = {})
      # Can do nothing in ruby 1.8.x
      return str unless str.respond_to?(:encoding)
      
      # We believe it's fastest to use built in #valid_encoding?
      # with it's C implementation, and bail out immediately if we need
      # to do nothing more, rather than stepping through byte by byte
      # in cases where the string was valid in the first place. 
      if str.valid_encoding?
        return str       
      elsif options[:invalid] != :replace
        # If we're not replacing, just raise right away without going through
        # chars for performance. 
        #
        # That does mean we're not able to say exactly what byte was bad though.
        # And the exception isn't filled out with all it's usual attributes,
        # which would be hard even we were going through all the chars/bytes. 
        raise  Encoding::InvalidByteSequenceError.new("invalid byte in string for source encoding #{str.encoding.name}")
      else   
        # :replace => :invalid, 
        # actually need to go through chars to replace bad ones

        replacement_char = options[:replace] || (
           # UTF-8 for unicode replacement char \uFFFD, encode in
           # encoding of input string, using '?' as a fallback where
           # it can't be (which should be non-unicode encodings)
           "\xEF\xBF\xBD".force_encoding("UTF-8").encode( str.encoding,
                                                    :undef => :replace,
                                                    :replace => '?' )
        )

        return str.chars.collect { |c| c.valid_encoding? ? c : replacement_char }.join
      end
    end
    
    # just like #ensure_valid_encoding, but actually mutates
    # the input string if neccesary to ensure validity (using String#replace), 
    # rather than returning the valid string. 
    #
    # ensure_valid_encoding!( some_string, :invalid => :replace )
    def self.ensure_valid_encoding!(str, options = {})
      # convenient to allow nil to be passed in, and just returned
      return nil if str.nil?
      
      str.replace(  ensure_valid_encoding(str, options) )
    end
    
    # instance version, so you can type less. 
    # 
    #    include EnsureValidEncoding
    #    ensure_valid_encoding(bad_str)
    def ensure_valid_encoding(*args)
      EnsureValidEncoding.ensure_valid_encoding(*args)
    end
    
    def ensure_valid_encoding!(*args)
      EnsureValidEncoding.ensure_valid_encoding!(*args)
    end
  
  
end
