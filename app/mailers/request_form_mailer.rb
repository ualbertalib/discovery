class RequestFormMailer < ApplicationMailer
  def bpsc_read_on_site_request(bpsc_read_on_site_request)
    @bpsc_read_on_site_request = bpsc_read_on_site_request
    mail(to: ['jeff.papineau@ualberta.ca', 'kzak@ualberta.ca'],
         subject: 'BPSC Retrieval Request (Read on Site)')
  end

  def rcrf_read_on_site_request(rcrf_read_on_site_request)
    @rcrf_read_on_site_request = rcrf_read_on_site_request
    mail(to: ['depository@ualberta.ca', 'ill@ualberta.ca'],
         subject: 'Request to View RCRF No Loan Items')
  end

  def rcrf_special_request(rcrf_special_request)
    @rcrf_special_request = rcrf_special_request
    mail(to: ['depository@ualberta.ca', 'ill@ualberta.ca'],
         subject: 'RCRF Depository Library Request Form (Microform/Newspapers)')
  end
end
