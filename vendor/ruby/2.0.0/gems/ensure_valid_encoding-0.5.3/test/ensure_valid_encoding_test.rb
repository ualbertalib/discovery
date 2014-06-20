require 'minitest/spec'
require 'minitest/autorun'

require 'ensure_valid_encoding'

describe EnsureValidEncoding do
  before do
    @bad_bytes_utf8   = "M\xE9xico".force_encoding("UTF-8")  
    @bad_bytes_utf16  = "M\x00\xDFxico".force_encoding( Encoding::UTF_16LE )
    @bad_bytes_ascii  = "M\xA1xico".force_encoding("ASCII")
  end
  
  it "raises on invalid bytes" do
    proc do
      EnsureValidEncoding.ensure_valid_encoding( @bad_bytes_utf8 )
    end.must_raise Encoding::InvalidByteSequenceError
  end
  
  it "replaces with unicode replacement string" do
    EnsureValidEncoding.ensure_valid_encoding(@bad_bytes_utf8, 
        :invalid => :replace).
      must_equal("M\uFFFDxico")
  end

  it "replaces with unicode relacement string for UTF16LE" do
    assert EnsureValidEncoding.ensure_valid_encoding(@bad_bytes_utf16,
        :invalid => :replace).valid_encoding?
  end
  
  it "replaces with chosen replacement string" do
    EnsureValidEncoding.ensure_valid_encoding(@bad_bytes_utf8, 
        :invalid => :replace, :replace => "*").
      must_equal("M*xico")
  end
  
  it "replaces with empty string" do
    EnsureValidEncoding.ensure_valid_encoding(@bad_bytes_utf8, 
        :invalid => :replace, :replace => '').
      must_equal("Mxico")
  end
  
  it "replaces non-unicode encoding with ? replacement str" do
    EnsureValidEncoding.ensure_valid_encoding(@bad_bytes_ascii,
        :invalid => :replace).
    must_equal("M?xico")    
  end
  
  describe "edge cases" do
    it "works with first byte bad" do
      str = "\xE9xico".force_encoding("UTF-8")
      EnsureValidEncoding.ensure_valid_encoding(str, 
          :invalid => :replace,
          :replace => "?").must_equal("?xico")          
    end
    
    it "works with last bad byte" do
      str = "Mexico\xE9".force_encoding("UTF-8")
      EnsureValidEncoding.ensure_valid_encoding(str, 
          :invalid => :replace,
          :replace => "?").must_equal("Mexico?")
    end
  end
  
  it "mutates" do
    EnsureValidEncoding.ensure_valid_encoding!(@bad_bytes_utf8, :invalid => :replace)
    @bad_bytes_utf8.must_equal("M\uFFFDxico")
  end
  
  describe "instance method versions" do
    before do
      @klass = Class.new do
        include EnsureValidEncoding
      end
    end
    
    it "ensure_valid_encoding" do
      @klass.new.ensure_valid_encoding("foo", :invalid => :replace)
    end
    
    it "ensure_valid_encoding!" do
      @klass.new.ensure_valid_encoding!("foo", :invalid => :replace) 
    end
    
  end
  
  describe "works for nil input" do
    it "with ensure_valid_encoding" do
      EnsureValidEncoding.ensure_valid_encoding(nil).must_be_nil
    end
    
    it "with ensure_valid_encoding!" do
      EnsureValidEncoding.ensure_valid_encoding!(nil).must_be_nil
    end
    
  end
end
