class PricingPlansController < ApplicationController
  def index
    @pricing_plans = PricingPlan.all
  end

  def checkout
    @pricing_plan = PricingPlan.find(params[:id])
  end
end
