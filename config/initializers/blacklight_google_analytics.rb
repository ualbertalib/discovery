# Change to your Google Web id 
BlacklightGoogleAnalytics.web_property_id = case Rails.env.to_s
when 'development'
  nil
when 'test'
  nil
else
  'UA-59249015-1'
end      
