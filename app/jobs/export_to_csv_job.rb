class ExportToCsvJob < ActiveJob::Base
  queue_as :default

  def perform(transactions, user, csv = true)
    filename = "Transactions-List-#{Time.now.utc.to_date.strftime("%Y-%m-%d")}.#{csv ? 'csv' : 'xls'}"
    if csv
      TransactionsMailer.export_transactions(Transaction.where(id: transactions).to_csv, filename, user).deliver
    else
      av = ActionView::Base.new(Rails.root.join('app', 'views'))
      data = av.render(template: "transactions/index.xls", locals: { transactions: Transaction.where(id: transactions) }, layout: nil)
      TransactionsMailer.export_transactions(data, filename, user).deliver
    end
  end
end
