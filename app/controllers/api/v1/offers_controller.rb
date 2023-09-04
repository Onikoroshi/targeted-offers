class Api::V1::OffersController < ApplicationController
  before_action :authenticate_user!

  def index
    offers = Offer.for_user(current_user)
    render json: offers
  end
end
