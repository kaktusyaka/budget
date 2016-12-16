class Ability
  include CanCan::Ability

  def initialize(user)
    can :manage, :all

    # if user.pricing_plan.mini?
    #   cannot :create, Transaction if user.transactions_this_month.count >= user.pricing_plan_quantity_of_transactions
    #   cannot :create, Category if user.categories_count >= user.pricing_plan_quantity_of_categories
    # end
  end
end
