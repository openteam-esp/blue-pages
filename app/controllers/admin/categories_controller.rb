class Admin::CategoriesController < Admin::ApplicationController
  belongs_to :parential_category,
             :class_name => 'Category',
             :optional => true,
             :param => :category_id

  def index
    index! {
      @categories = current_user.categories
      render :index, :layout => 'admin' and return
    }
  end

  def create
    create! { |success, failure|
      success.html { redirect_to admin_category_path(@category) }
    }
  end

  def destroy
    destroy! { @category.parent ? admin_category_path(@category.parent) : admin_categories_path }
  end

  def sort
    index! do
      params[:ids].each_with_index do |id, index|
        category = Category.find(id)
        category.update_attribute(:position, index.to_i + 1)
      end
      render :nothing => true, :status => 200 and return
    end
  end

  def treeview
    result = []
    Category.find(params[:root]).children.each do | category |
      result << fill_category(category)
    end
    render :json => result, :layout => false
  end

  protected

    def collection_path
      @parential_category ? admin_category_categories_path(@parential_category) : admin_categories_path
    end

  private

    def fill_category(category)
      hash = { 'text' => "<a href='/admin/#{category.class.name.tableize}/#{category.id}'>#{category.title}</a>" }
      hash.merge!({ 'id' => category.id.to_s, 'hasChildren' => true }) if category.has_children?
      hash
    end

end
