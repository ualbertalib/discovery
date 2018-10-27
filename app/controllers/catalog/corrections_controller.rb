class Catalog::CorrectionsController < ApplicationController

  def new
    @correction = Correction.new(item_id: params[:item_id])
  end

  def create
    @correction = Correction.new(correction_params)

    if @correction.valid?
      CorrectionMailer.notify(@correction).deliver_now
      if @correction.item_id.present?
        redirect_to catalog_path(@correction.item_id)
      else
        redirect_to root_path
      end
      flash[:success] = "Thank you! We have received your correction and will be reviewing it soon."
    else
      flash[:error] = "There was an error sending your message. Please try again."
      render :new
    end
  end

  private

  def correction_params
    params.require(:correction).permit(:message, :item_id)
  end
end
