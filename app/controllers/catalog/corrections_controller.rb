class Catalog::CorrectionsController < ApplicationController
  before_action :set_item_id, only: [:new, :create]

  def new; end

  def create
    CorrectionsMailer.corrections_email(@item_id, params[:message]).deliver_now

    # Email successfully delivered.
  end

  private

  def set_item_id
    @item_id = params[:item_id]
  end
end
