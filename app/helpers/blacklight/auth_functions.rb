module Blacklight::Auth_Functions
  ############
  # File / Token Handling / End User Auth
  ############

  def authenticated_user?
    if user_signed_in?
      return true
    end
    # need to define function for detecting on-campus IP ranges
    return false
  end

  def clear_session_key
    session.delete(:session_key)
  end
  
  def get_session_key
    if session[:session_key].present?
      return session[:session_key].to_s
    else
      return "no session key"
    end
  end

  def token_file_exists?
    if File.exists?(token_file_location)
      return true
    end
    return Rails.root.to_s + "/token.txt"
  end
  
  def auth_file_exists?
    if File.exists?(auth_file_location)
      return true
    end
    return Rails.root.to_s + "/APIauthentication.txt"
  end
  
  def token_file_location
    if request.domain.to_s.include?("localhost")
      return "token.txt"
    end
    return Rails.root.to_s + "/token.txt"
  end
  
  def auth_file_location
    if request.domain.to_s.include?("localhost")
      return "APIauthentication.txt"
    end
    return Rails.root.to_s + "/APIauthentication.txt"
  end

  # returns true if the authtoken stored in token.txt is valid
  # false if otherwise
  def has_valid_auth_token?
    token = timeout = timestamp = ''
    if token_file_exists?
      File.open(token_file_location,"r") {|f|
        if f.readlines.size <= 2
          return false
        end
      }
      File.open(token_file_location,"r") {|f|
          token = f.readline.strip
          timeout = f.readline.strip
          timestamp = f.readline.strip
      }
    else
      return false 
    end
    if Time.now.getutc.to_i < timestamp.to_i
      return true
    else
      #session[:debugNotes] << "<p>Looks like the auth token is out of date.. It expired at " << Time.at(timestamp.to_i).to_s << "</p>"
      return false
    end
  end
  
  def get_token_timeout
    timestamp = '';
    File.open(token_file_location,"r") {|f|
        token = f.readline.strip
        timeout = f.readline.strip
        timestamp = f.readline.strip
    }
    return Time.at(timestamp.to_i)
  end
  
  # writes an authentication token to token.txt.
  # will create token.txt if it does not exist
  def writeAuthToken(auth_token)
    timeout = "1800"
    timestamp = Time.now.getutc.to_i + timeout.to_i
    timestamp = timestamp.to_s
    auth_token = auth_token.to_s
    
    if File.exists?(token_file_location)
      File.open(token_file_location,"w") {|f|
        f.write(auth_token)
        f.write("\n" + timeout)
        f.write("\n" + timestamp)
      }
    else
      File.new(token_file_location,"w") {|f|
        f.write(auth_token)
        f.write("\n" + timeout)
        f.write("\n" + timestamp)
      }
      File.chmod(664,token_file_location)
      File.open(token_file_location,"w") {|f|
        f.write(auth_token)
        f.write("\n" + timeout)
        f.write("\n" + timestamp)
      }
    end
  end
  
  def getAuthToken
    token = ''
    timeout = ''
    timestamp = ''
    if has_valid_auth_token?
      File.open(token_file_location,"r") {|f|
        token = f.readline.strip
      }
      return token
    end
    return token
  end

end
