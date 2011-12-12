class Admin::CategoriesController < Admin::ApplicationController
  belongs_to :parent_category, :class_name => 'Category', :optional => true, :param => :category_id

  def index
    index! {
      @categories = Category.roots
    }
  end

  def sort
    index! do
      params[:ids].each_with_index do |id, index|
        category = Category.find(id)
        category.update_attribute(:position, index.to_i+1)
      end

      return :nothing => true, :status => 200
    end
  end
end
