class PricingPlansController < ApplicationController
  def index
    @pricing_plans = PricingPlan.all
  end
end
