class BPSCReadOnSiteRequestsController < ApplicationController
  def new
    # Referer used to store an immutable item url for redirection.
    @bpsc_read_on_site_request = BPSCReadOnSiteRequest.new(item_url: params[:item_url],
                                                           title: params[:title],
                                                           call_number: params[:call_number],
                                                           referer: params[:item_url])
  end

  def create
    @bpsc_read_on_site_request = BPSCReadOnSiteRequest.new(bpsc_read_on_site_request_params)

    if @bpsc_read_on_site_request.valid?
      RequestFormMailer.bpsc_read_on_site_request(@bpsc_read_on_site_request).deliver_now
      flash[:success] = t('request_form_success')
      redirect_to @bpsc_read_on_site_request.referer.present? ? @bpsc_read_on_site_request.referer : root_path
    else
      flash[:error] = t('request_form_error')
      render :new
    end
  end

  private

  def bpsc_read_on_site_request_params
    params.require(:bpsc_read_on_site_request).permit(:name,
                                                      :email,
                                                      :appointment_time,
                                                      :title,
                                                      :call_number,
                                                      :item_url,
                                                      :notes,
                                                      :referer)
  end
end
