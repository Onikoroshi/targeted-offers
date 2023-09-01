class Api::V1::OffersController < ApplicationController
  before_action :authenticate_user!

  def index
    offers = Offer.all
    render json: offers
  end
end
