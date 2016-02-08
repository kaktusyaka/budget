class TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :edit, :update, :destroy]

  def index
    @transactions = current_user.transactions
  end

  def show
  end

  def new
    @transaction = Transaction.new
  end

  def edit
  end

  private
    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    def transaction_params
      params.require(:transaction).permit(:user_id, :category_id, :income, :date, :amount, :description)
    end
end
