# -*- encoding : utf-8 -*-
# Only works for documents with a #to_marc right now. 
class RecordMailer < ActionMailer::Base
  def email_record(documents, details, url_gen_params)
    #raise ArgumentError.new("RecordMailer#email_record only works with documents with a #to_marc") unless document.respond_to?(:to_marc)
        
    subject = "From University of Alberta Libraries: #{documents.first.to_semantic_values[:title].first}"

    @count          = documents.length
    @documents      = documents
    @message        = details[:message]
    @call           = details[:call]
    @location       = details[:location]
    @url_gen_params = url_gen_params

    mail(:to => details[:to],  :subject => subject, :from => "no-reply@ualberta.ca")
  end
  
  def sms_record(documents, details, url_gen_params)
    @documents      = documents
    @url_gen_params = url_gen_params
    details[:call].empty? ? subject = "From University of Alberta Libraries: #{documents.first.to_semantic_values[:title].first}" : subject = details[:call]
    mail(:to => details[:to], :subject => subject, :from => "no-reply@ualberta.ca")
  end

end
