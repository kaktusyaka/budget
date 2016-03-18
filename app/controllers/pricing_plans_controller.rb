class PricingPlansController < ApplicationController
  def index
    @pricing_plans = PricingPlan.all
  end

  def checkout
    @pricing_plan = PricingPlan.find(params[:id])
  end

  def upgrade
    @pricing_plan = PricingPlan.find(params[:id])
    begin
      current_user.create_stripe_customer(params[:stripeToken]) if current_user.stripe_id.blank?
      current_user.pay!(@pricing_plan)
      flash[:success] = "You Pricing plan was successfully upgrated. Congrates with #{ current_user.pricing_plan.name.capitalize } pricing plan!"
      redirect_to root_path
    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to checkout_pricing_plan_path(@pricing_plan)
    end
  end

  def downgrade
    current_user.send(:set_default_pricing_plan, true)
    flash[:success] = "You Pricing plan was successfully downgrated to #{ current_user.pricing_plan.name.capitalize } pricing plan!"
    redirect_to root_path
  end
end
