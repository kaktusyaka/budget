# Preview all emails at http://localhost:3000/rails/mailers/transactions_mailer
class TransactionsMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/transactions_mailer/export_transactions
  def export_transactions
    TransactionsMailer.export_transactions
  end

end
