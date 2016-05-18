require_relative "./connection.rb"

	# Handles connections - retries failed connections, passes commands along
	class ConnectionHandler < Connection
		attr_accessor :max_retries
		attr_accessor :session_token
		def initialize(max_retries = 2)
			@max_retries = max_retries
		end
		def show_session_token
		  return @session_token
		end
		def show_auth_token
		  return @auth_token
		end
		# def create_session(auth_token = @auth_token, format = :xml)
		# 	@auth_token = auth_token
  	# 		result = JSON.parse(super())
		# 	  if result.has_key?('ErrorNumber')
		# 		return result.to_s
		# 	  else
		# 		@session_token = result['SessionToken']
		# 	  	return result['SessionToken']
		# 	  end
		# end
		def create_session(format = :xml)
			#@auth_token = auth_token
  		result = JSON.parse(super())
			@session_token = result['SessionToken']
		end
		def search(options, session_token, auth_token, format = :xml)
			attempts = 0
			@session_token = session_token
			@auth_token = auth_token
			loop do
				result = JSON.parse(super(options, format))
				if result.has_key?('ErrorNumber')
					#@debug_notes << "<p>Found ERROR " << result['ErrorNumber'].to_s
					case result['ErrorNumber']
					      when "108"
						      @session_token = self.create_session
						      result = JSON.parse(super(options, format))
					      when "109"
						      @session_token = self.create_session
						      result = JSON.parse(super(options, format))
					      when "104"
						      self.uid_authenticate(:json)
						      result = JSON.parse(super(options, format))
					      when "107"
						      self.uid_authenticate(:json)
						      result = JSON.parse(super(options, format))
					      else
						      return result	
					end
					unless result.has_key?('ErrorNumber')
						return result
					end
					attempts += 1
					if attempts >= @max_retries
					      return result
					end
				else
				      return result
				end
			end
		end
	        def info (session_token, auth_token, format= :xml)
		   attempts = 0
		   @auth_token = auth_token
		   @session_token = session_token
			loop do
			  result = JSON.parse(super(format)) # JSON Parse
			  if result.has_key?('ErrorNumber')
				  case result['ErrorNumber']
				  	when "108"
				  		@session_token = self.create_session
				  	when "109"
				  		@session_token = self.create_session
				  	when "104"
				  		self.uid_authenticate(:json)
					when "107"
						self.uid_authenticate(:json)
				  end
				  attempts += 1
				  if attempts >= @max_retries
				  	return result
				  end
			  else
			  	return result
			  end
	                end
	        end
	        def retrieve(dbid, an, highlightterms, session_token, auth_token, format = :xml)
			attempts = 0
			@session_token = session_token
			@auth_token = auth_token
			loop do
			  result = JSON.parse(super(dbid, an, highlightterms, format))
			  if result.has_key?('ErrorNumber')
				  case result['ErrorNumber']
				  	when "108"
				  		@session_token = self.create_session
				  	when "109"
				  		@session_token = self.create_session
				  	when "104"
				  		self.uid_authenticate(:json)
					when "107"
						self.uid_authenticate(:json)
				  end
				  attempts += 1
				  if attempts >= @max_retries
					return result
				  end
			  else
			  	return result
			  end
		  end
		end
	end

# Benchmark response times
def benchmark(q = false)
	start = Time.now
	connection = ConnectionHandler.new(2)
	connection.uid_init('USERID', 'PASSWORD', 'PROFILEID')
	connection.uid_authenticate(:json)
	puts((start - Time.now).abs) unless q
	connection.create_session
	puts((start - Time.now).abs) unless q
	connection.search('query-1=AND,galapagos+hawk', :json)
	puts((start - Time.now).abs) unless q
	connection.end_session
	puts((start - Time.now).abs) unless q
end

# Run benchmark with warm up run; only if file was called directly and not required
# if __FILE__ == $0
# 	benchmark(true)
# 	benchmark
# end
