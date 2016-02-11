class CategoriesController < ApplicationController
  def index
    @categories = current_user.categories
  end

  def new
    @category = Category.new
  end

  def sort
    params[:category].each_with_index do |id, index|
      Category.find(id).update_column :position, index+1
    end
    render nothing: true
  end
end
