class BPSCReadOnSiteRequestsController < ApplicationController
  def new
    @bpsc_read_on_site_request = BPSCReadOnSiteRequest.new(item_url: params[:item_url])
  end

  def create
    @bpsc_read_on_site_request = BPSCReadOnSiteRequest.new(bpsc_read_on_site_request_params)

    if @bpsc_read_on_site_request.valid?
      RequestFormMailer.bpsc_read_on_site_request(@bpsc_read_on_site_request).deliver_now
      flash[:success] = 'Thank you! We have received your correction and will be reviewing it soon.'
      redirect_to root_path
    else
      flash[:error] = 'There was an error sending your message. Please try again.'
      render :new
    end
  end

  private

  def bpsc_read_on_site_request_params
    params.require(:bpsc_read_on_site_request).permit(:name,
                                              :email,
                                              :appointment_time,
                                              :title,
                                              :item_url,
                                              :notes)
  end
end
