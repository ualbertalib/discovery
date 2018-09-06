module SubjectHelper
     def subject_query(subject, index)
       i = 0
       sbstring = "" 
       while i <= index
          sbstring += subject[i].delete(".").delete("&").tr("+", " ")
          sbstring = sbstring unless i == index
          i+= 1
       end
       sbstring = "\"#{sbstring}\""
       sbstring
     end  
end
