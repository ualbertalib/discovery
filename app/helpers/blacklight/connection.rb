
	# Connection object. Does what it says. ConnectionHandler is what is usually desired and wraps auto-reonnect features, etc.
	class Connection
	
    API_URL = "http://eds-api.ebscohost.com/"
    API_URL_S = "https://eds-api.ebscohost.com/"

	  attr_accessor :auth_token, :session_token, :debug_notes, :guest
	  attr_writer :userid, :password
	  
	  # Init the object with userid and pass.
		def uid_init(userid, password, profile, guest = 'y')
			#@debug_notes = "<p>Setting guest as " << guest.to_s << "</p>"
			@userid = userid
			@password = password
			@profile = profile
			@guest = guest
			return self
		end
		def ip_init(profile, guest = 'y')
			@profile = profile
			@guest = guest
			return self
		end
		# Auth with the server. Currently only uid auth is supported.
		
		###
		def uid_authenticate(format = :xml)
			# DO NOT SEND CALL IF YOU HAVE A VALID AUTH TOKEN
			xml = "<UIDAuthRequestMessage xmlns='http://www.ebscohost.com/services/public/AuthService/Response/2012/06/01'><UserId>#{@userid}</UserId><Password>#{@password}</Password></UIDAuthRequestMessage>"
			uri = URI "#{API_URL_S}authservice/rest/uidauth"
			req = Net::HTTP::Post.new(uri.request_uri)
			req["Content-Type"] = "application/xml"
			req["Accept"] = "application/json" #if format == :json
			req.body = xml
			#@debug_notes << "<p>UID Authentication Call to " << uri.to_s << ": " << xml << "</p>";
			https = Net::HTTP.new(uri.hostname, uri.port)
			https.use_ssl = true
			https.verify_mode = OpenSSL::SSL::VERIFY_NONE
			begin
			  doc = JSON.parse(https.request(req).body)
			rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
			  about "No response from server"
			end
			if doc.has_key?('ErrorNumber')
			   abort "Bad response from server - error code #{result['ErrorNumber']}"
			else
			   @auth_token = doc['AuthToken']
			end			
		end
		def ip_authenticate(format = :xml)
			uri = URI "#{API_URL_S}authservice/rest/ipauth"
      req = Net::HTTP::Post.new(uri.request_uri)
			req["Accept"] = "application/json" #if format == :json
			https = Net::HTTP.new(uri.hostname, uri.port)
			https.use_ssl = true
			https.verify_mode = OpenSSL::SSL::VERIFY_NONE
			begin
			  doc = JSON.parse(https.request(req).body)
			rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
			  abort "No response from server"
			end
			@auth_token = doc['AuthToken']
		end
		# Create the session
		def create_session
			uri = URI "#{API_URL}edsapi/rest/createsession?profile=#{@profile}&guest=#{@guest}"
			req = Net::HTTP::Get.new(uri.request_uri)
			#req['x-authenticationToken'] = @auth_token
			req['Accept'] = "application/json"
			#@debug_notes << "<p>CREATE SESSION Call to " << uri.to_s << " with auth token: " << req['x-authenticationToken'].to_s << "</p>";
#			Net::HTTP.start(uri.hostname, uri.port) { |http|
#  			doc = JSON.parse(http.request(req).body)
#				return doc['SessionToken']
#			}
			Net::HTTP.start(uri.hostname, uri.port) { |http|
  			begin
			  return http.request(req).body
			rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
			  abort "No response from server"
			end
			}
		end
		# End the session
		def end_session(session_token)
			uri = URI "#{API_URL}edsapi/rest/endsession?sessiontoken=#{CGI::escape(session_token)}"
			req = Net::HTTP::Get.new(uri.request_uri)
			req['x-authenticationToken'] = @auth_token
			Net::HTTP.start(uri.hostname, uri.port) { |http|
  			begin
			  http.request(req)
			rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
			  abort "No response from server"
			end
			}
			return true
		end
		# Run a search query, XML results are returned
        def search(options, format = :xml)
			uri = URI "#{API_URL}edsapi/rest/Search?#{options}"
			#return uri.request_uri
			req = Net::HTTP::Get.new(uri.request_uri)
			req['x-authenticationToken'] = @auth_token
			req['x-sessionToken'] = @session_token
			req['Accept'] = 'application/json' #if format == :json
			#@debug_notes << "<p>SEARCH Call to " << uri.to_s << " with auth token: " << req['x-authenticationToken'].to_s << " and session token: " << req['x-sessionToken'].to_s << "</p>";

			Net::HTTP.start(uri.hostname, uri.port) { |http|
  			begin
			  return http.request(req).body
			rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
			  abort "No response from server"
			end
			}
        end
	  # Retrieve specific information
		def retrieve(dbid, an, highlightterms = "", format = :xml)
			uri = URI "#{API_URL}edsapi/rest/retrieve?dbid=#{dbid}&an=#{an}"
			if highlightterms != ""
				uri = URI "#{API_URL}edsapi/rest/retrieve?dbid=#{dbid}&an=#{an}&highlightterms=#{highlightterms}"
			end
			req = Net::HTTP::Get.new(uri.request_uri)
			req['x-authenticationToken'] = @auth_token
			req['x-sessionToken'] = @session_token
			req['Accept'] = 'application/json' #if format == :json
			#@debug_notes << "<p>RETRIEVE Call to " << uri.to_s << " with auth token: " << req['x-authenticationToken'].to_s << " and session token: " << req['x-sessionToken'].to_s << "</p>";

			Net::HTTP.start(uri.hostname, uri.port) { |http|
  			begin
			  return http.request(req).body
			rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
			  abort "No response from server"
			end
			}
		end
		# Info method
		def info(format = :xml)
			uri = URI "#{API_URL}edsapi/rest/Info"
			req = Net::HTTP::Get.new(uri.request_uri)
			req['x-authenticationToken'] = @auth_token
			req['x-sessionToken'] = @session_token
			req['Accept'] = 'application/json' #if format == :json
			#@debug_notes << "<p>INFO Call to " << uri.to_s << " with auth token: " << req['x-authenticationToken'].to_s << " and session token: " << req['x-sessionToken'].to_s << "</p>";
			Net::HTTP.start(uri.hostname, uri.port) { |http|
  			begin
			  return http.request(req).body
			rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
			  abort "No response from server"
			end
			}
		end
	end
