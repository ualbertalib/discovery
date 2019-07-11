class RCRFSpecialRequestsController < ApplicationController
  def new
    @rcrf_special_request = RCRFSpecialRequest.new(item_url: params[:item_url],
                                                   title: params[:title],
                                                   referer: params[:item_url])
  end

  def create
    @rcrf_special_request = RCRFSpecialRequest.new(rcrf_special_request_params)

    if @rcrf_special_request.valid?
      RequestFormMailer.rcrf_special_request(@rcrf_special_request).deliver_now
      flash[:success] = t('request_form_success')
      redirect_to @rcrf_special_request.referer.present? ? @rcrf_special_request.referer : root_path
    else
      flash[:error] = t('request_form_error')
      render :new
    end
  end

  private

  def rcrf_special_request_params
    params.require(:rcrf_special_request).permit(:name,
                                                 :email,
                                                 :title,
                                                 :item_url,
                                                 :notes,
                                                 :library,
                                                 :referer)
  end
end
