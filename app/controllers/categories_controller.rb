class CategoriesController < ApplicationController

  def index
    @categories = current_user.categories
  end

  def new
    @category = Category.new
  end

  def create
    @category = current_user.categories.build(category_params)
    if @category.save
      redirect_to @category, notice: "Category was successfully created"
    else
      render :new
    end
  end


  def sort
    params[:category].each_with_index do |id, index|
      Category.find(id).update_column :position, index+1
    end
    render nothing: true
  end

  private
    def set_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:name, :user_id)
    end
end
