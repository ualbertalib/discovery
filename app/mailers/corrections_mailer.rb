class CorrectionsMailer < ApplicationMailer

  default from: "noreply@library.ualberta.ca"


  def corrections_email(item_id, message)
    @item_id = item_id
    @message = message
    #mail(to: "libraryhelpdesk@ualberta.ca", subject: "Cataloguing Correction Submitted")
    mail(to: "spopowic@ualberta.ca", subject: "Cataloguing Correction Submitted")
  end
end
