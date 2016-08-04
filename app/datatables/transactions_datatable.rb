class TransactionsDatatable
  include TransactionsHelper
  include Haml::Helpers
  include Rails.application.routes.url_helpers

  delegate :params, :h, :number_to_currency, :link_to, :raw, to: :@view

  def initialize view, current_user
    @view = view
    @current_user = current_user
    init_haml_helpers
  end

  def as_json(options ={})
    {
      draw: params[:sEcho].to_i,
      recordsTotal: transactions.count,
      recordsFiltered: transactions.total_count,
      data: data,

      expenditures_amount: filtered_transactions(params).expenditures_amount.sum(:amount)
    }
  end

  private
  def data
    transactions.map do |transaction|
      [
        transaction.category.name,
        type( transaction.income),
        transaction.date.strftime('%d/%m/%Y'),
        number_to_currency( transaction.amount ),
        raw( transaction.description ),
        "#{link_to( 'Edit', edit_transaction_path(transaction), data: { :'remote-target' => '#transactions-form .modal-content' }, class: 'open-transaction-js', title: 'Edit')} #{link_to( 'Destroy', transaction_path(transaction, format: :json), class: 'delete-transaction-js' )}"
      ]
    end
  end

  def transactions
    @transactions ||= fetch_transactions
  end

  def fetch_transactions
    transactions = filtered_transactions(params)
    transactions.page(page).per(per_page)
  end

  def filtered_transactions(attr)
    set_transactions.reorder("#{sort_column} #{sort_direction}").search(attr)
  end

  def page
    params[:start].to_i/per_page + 1
  end

  def per_page
    if params[:length].to_i < 0
      set_transactions.count
    else
      params[:length].to_i > 0 ? params[:length].to_i : 10
    end
  end

  def sort_column
    columns = ["categories.name", "income", "date", "amount", "description"]
    columns[params[:order]['0'][:column].to_i]
  end

  def sort_direction
    params[:order]['0'][:dir] == "asc" ? "asc" : "desc"
  end

  def set_transactions
    @current_user.transactions.includes(:category)
  end
end
