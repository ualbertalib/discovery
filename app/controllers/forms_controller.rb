class FormsController < ApplicationController

  def index

  end

  def show
    @item_id = params[:item_id]
  end

  def send_email
    logger.info "Send Email Called"
    CorrectionsMailer.corrections_email(params[:item_id], params[:message]).deliver_now
  end
end
