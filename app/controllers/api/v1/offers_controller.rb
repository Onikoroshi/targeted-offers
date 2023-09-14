class Api::V1::OffersController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: build_available_and_chosen_offers
  end

  def choose_offer
    found_offer = Offer.for_user(current_user).find(params[:offer_id])
    current_user.choose_offer!(found_offer)

    render json: build_available_and_chosen_offers
  end

  private

  def build_available_and_chosen_offers
    available_offers = Offer.unchosen_by(current_user).for_user(current_user)
    chosen_offers = current_user.chosen_offers

    {
      available_offers: available_offers,
      chosen_offers: chosen_offers
    }
  end
end
