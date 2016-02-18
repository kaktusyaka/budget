class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:edit, :update, :destroy]
  before_action :set_transactions, only: [:create, :index]

  def index
    @q = @transactions.search(params[:q])
    @q.sorts = ['date desc'] if @q.sorts.empty?
    @transactions = @q.result.includes(:category).page(params[:page])
    gon.expenditures_by_category = @transactions.this_month.map {|t| [t.category.name, t.amount.to_f]}
    gon.expenditures_by_category.unshift(['Categoty Name', 'Amount'])
  end

  def new
    @transaction = Transaction.new
  end

  def edit
  end

  def create
    @transaction = @transactions.build(transaction_params)

    if @transaction.save
      redirect_to transactions_url, notice: 'Transaction was successfully created.'
    else
      render :new
    end
  end

  def update
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
    def set_transactions
      @transactions = current_user.transactions
    end

    def set_transaction
      @transaction = set_transactions.find(params[:id])
    end

    def transaction_params
      params.require(:transaction).permit(:user_id, :category_id, :income, :date, :amount, :description)
    end
end
