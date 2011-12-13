class Admin::CategoriesController < Admin::ApplicationController
  belongs_to :parential_category,
             :class_name => 'Category',
             :optional => true,
             :param => :category_id

  def index
    index! {
      @categories = Category.roots
      render :layout => 'admin' and return
    }
  end

  def create
    create! { admin_category_path(@category) }
  end

  def destroy
    destroy! { @category.parent ? admin_category_path(@category.parent) : admin_categories_path }
  end

  def index
    index! {
      @categories = Category.roots
    }
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
    categories = params[:root].eql?('source') ? Category.all : Category.find(params[:root]).children
    categories.each do | category |
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
