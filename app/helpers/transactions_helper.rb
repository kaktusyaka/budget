module TransactionsHelper
  def type (income)
   income ? "Income" : "Expenditure"
  end
end
