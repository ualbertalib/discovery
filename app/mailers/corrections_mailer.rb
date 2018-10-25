class CorrectionsMailer < ApplicationMailer
  def corrections_email(item_id, message)
    @item_url = catalog_url(item_id)
    @message = message
    mail(to: "libraryhelpdesk@ualberta.ca", subject: "Cataloguing Correction Submitted")
  end
end
