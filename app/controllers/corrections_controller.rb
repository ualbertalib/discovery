class CorrectionsController < ApplicationController

  def new
    @correction = Correction.new(catalog_id: params[:catalog_id])
  end

  def create
    @correction = Correction.new(correction_params)

    if @correction.valid?
      CorrectionMailer.notify(@correction).deliver_now
      flash[:success] = 'Thank you! We have received your correction and will be reviewing it soon.'
      redirect_to catalog_path(@correction.catalog_id)
    else
      flash[:error] = 'There was an error sending your message. Please try again.'
      render :new
    end
  end

  private

  def correction_params
    params.require(:correction).permit(:message, :catalog_id)
  end
end
