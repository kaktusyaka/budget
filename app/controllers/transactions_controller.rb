class TransactionsController < ApplicationController
  before_action :find_transaction, only: [:edit, :update, :destroy]
  before_action :set_gon_category_names, only: [:new, :edit, :create, :update]

  def index
    @transactions = current_user.transactions.includes(:category)
    #@transactions = @transactions.page(params[:page])

    gon.expenditures_by_category = Transaction.expenditures_this_month(@transactions).unshift(['Categoty Name', 'Amount'])
    gon.balances_for_chart = @transactions.weekly_balances.unshift(['Week', 'Balance', 'Average'])

    @current_balance = @transactions.current_balance
  end

  def new
    @transaction = Transaction.new
  end

  def edit
  end

  def create
    @transaction = Transaction.new(transaction_params)
    @transaction.user_id = current_user.id

    if @transaction.save
      redirect_to transactions_url, notice: 'Transaction was successfully created.'
    else
      render :new
    end
  end

  def update
    @transaction.user_id = current_user.id
    if @transaction.update(transaction_params)
      redirect_to transactions_url, notice: 'Transaction was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @transaction.destroy
    redirect_to transactions_url, notice: 'Transaction was successfully destroyed.'
  end

  private
    def find_transaction
      @transaction = Transaction.find(params[:id])
    end

    def transaction_params
      params.require(:transaction).permit(:category_name, :income, :date, :amount, :description)
    end

    def set_gon_category_names
      gon.user_categories = current_user.categories.pluck(:name)
    end
end
