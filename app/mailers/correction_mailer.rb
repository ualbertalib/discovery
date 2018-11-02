class CorrectionMailer < ApplicationMailer
  def notify(correction)
    @correction = correction
    mail(to: 'libraryhelpdesk@ualberta.ca', subject: 'Cataloguing Correction Submitted')
  end
end
