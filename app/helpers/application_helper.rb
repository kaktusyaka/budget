module ApplicationHelper
  ["categories", "transactions"].each do |page|
    define_method("#{page}_active?") do
      [page.to_sym].include?(controller_name.to_sym)
    end
  end
end
