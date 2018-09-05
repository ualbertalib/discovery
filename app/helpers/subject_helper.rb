module SubjectHelper

   	def subject_query(subject, index)
   		i = 0
        sbstring = "" 
        while( i <= index )
       		sbstring = sbstring + subject[i].gsub(".","").gsub("&","").gsub("+"," ")
            	unless i == index
                	sbstring = sbstring
                end
            i+= 1
        end
   		subject_query = "\"#{sbstring}\""
   	end
   	
end
