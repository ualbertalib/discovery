class RCRFSpecialRequestsController < ApplicationController
  def new
    @rcrf_special_request = RCRFSpecialRequest.new(item_url: params[:item_url])
  end

  def create
    @rcrf_special_request = RCRFSpecialRequest.new(rcrf_special_request_params)

    if @rcrf_special_request.valid?
      RequestFormMailer.rcrf_special_request(@rcrf_special_request).deliver_now
      flash[:success] = 'Thank you! We have received your correction and will be reviewing it soon.'
      redirect_to root_path
    else
      flash[:error] = 'There was an error sending your message. Please try again.'
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
                                                 :library)
  end
end
