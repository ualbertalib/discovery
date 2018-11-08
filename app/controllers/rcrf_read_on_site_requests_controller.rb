class RCRFReadOnSiteRequestsController < ApplicationController
  def new
    @rcrf_read_on_site_request = RCRFReadOnSiteRequest.new(item_url: params[:item_url])
  end

  def create
    @rcrf_read_on_site_request = RCRFReadOnSiteRequest.new(rcrf_read_on_site_request_params)

    if @rcrf_read_on_site_request.valid?
      RequestFormMailer.rcrf_read_on_site_request(@rcrf_read_on_site_request).deliver_now
      flash[:success] = 'Thank you! We have received your correction and will be reviewing it soon.'
      redirect_to root_path
    else
      flash[:error] = 'There was an error sending your message. Please try again.'
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
                                              :notes)
  end
end
