class ExportToCsvJob < ActiveJob::Base
  queue_as :default

  def perform transactions, user
    filename = "Transactions-List-#{Time.now.utc.to_date.strftime("%Y-%m-%d")}.csv"
    TransactionsMailer.export_transactions(Transaction.where(id: transactions).to_csv, filename, user).deliver
  end
end
