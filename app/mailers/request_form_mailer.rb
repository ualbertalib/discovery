class RequestFormMailer < ApplicationMailer
  def bpsc_read_on_site_request(bpsc_read_on_site_request)
    @bpsc_read_on_site_request = bpsc_read_on_site_request
    mail(to: ['jeff.papineau@ualberta.ca', 'kzak@ualberta.ca'],
         subject: t('bpsc_read_on_site_requests.new.header'))
  end

  def rcrf_read_on_site_request(rcrf_read_on_site_request)
    @rcrf_read_on_site_request = rcrf_read_on_site_request
    mail(to: ['depository@ualberta.ca'],
         subject: t('rcrf_read_on_site_requests.new.header'))
  end

  def rcrf_special_request(rcrf_special_request)
    @rcrf_special_request = rcrf_special_request
    mail(to: ['depository@ualberta.ca', 'ill@ualberta.ca'],
         subject: t('rcrf_special_requests.new.header'))
  end
end
