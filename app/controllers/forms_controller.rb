# frozen_string_literal: true

class FormsController < ApplicationController
  def index; end

  def show
    @@item_id = params[:item_id]
  end

  def send_email
    logger.info 'Send Email Called'
    CorrectionsMailer.corrections_email(@@item_id, params[:message], (request.protocol + request.host).to_s).deliver_now
  end
end
