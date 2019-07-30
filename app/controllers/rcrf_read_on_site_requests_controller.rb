class RCRFReadOnSiteRequestsController < ApplicationController
  def new
    # Referer used to store an immutable item url for redirection.
    @rcrf_read_on_site_request = RCRFReadOnSiteRequest.new(item_url: params[:item_url],
                                                           title: params[:title],
                                                           referer: params[:item_url])
  end

  def create
    @rcrf_read_on_site_request = RCRFReadOnSiteRequest.new(rcrf_read_on_site_request_params)

    if @rcrf_read_on_site_request.valid?
      RequestFormMailer.rcrf_read_on_site_request(@rcrf_read_on_site_request).deliver_now
      flash[:success] = t('request_form_success')

      # ensure that this isn't being used maliciously to redirect away from our site
      redirect_to URI.parse(@rcrf_read_on_site_request.referer.present? ? @rcrf_read_on_site_request.referer : root_path).path
    else
      flash[:error] = t('request_form_error')
      render :new
    end
  end

  private

  def rcrf_read_on_site_request_params
    params.require(:rcrf_read_on_site_request).permit(:name,
                                                      :email,
                                                      :viewing_location,
                                                      :appointment_time,
                                                      :title,
                                                      :item_url,
                                                      :notes,
                                                      :referer)
  end
end
