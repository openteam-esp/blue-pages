ActiveAdmin.register Category do
  belongs_to :parent_category, :optional => true, :class_name => "Category"

  filter :title
  filter :updated_at

  index do
    column :title do |category|
      link_to category.title, admin_category_path(category)
    end
    column :abbr
    column :updated_at
  end

  config.clear_action_items!

  action_item :only => :show do
    link_to(I18n.t("active_admin.edit_#{resource.class.to_s.downcase}"),
            edit_resource_path,
            :class => 'button icon edit') if can?(:edit, resource)
  end

  action_item :only => :show do
    link_to(I18n.t("active_admin.delete_#{resource.class.to_s.downcase}"),
            resource.parent ? admin_parent_category_category_path(resource.parent, resource) : resource_path,
            :method => :delete,
            :confirm => I18n.t('active_admin.delete_confirmation'),
            :class => 'button icon trash danger') if can?(:destroy, resource)
  end

  menu :priority => 2


  show :title => proc { category.title } do
    div do
      render 'show', :children => category.children
    end
  end

  form :partial => 'form'

  collection_action :sort, :method => :post do
    index! do
      authorize! :manage, @parent_category
      params[:ids].each_with_index do |id, index|
        category = Category.find(id)
        category.update_attribute(:position, index.to_i+1)
      end
      head 200 and return
    end
  end

  controller do
    authorize_resource

    protected

      def collection_path
        return admin_category_path(@parent_category) if @parent_category
        admin_categories_path
      end
  end
end
