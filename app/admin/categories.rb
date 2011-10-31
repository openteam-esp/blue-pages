ActiveAdmin.register Category do
  belongs_to :category, :optional => true

  config.clear_sidebar_sections!
  config.clear_action_items!

  action_item :only => :show do
    link_to(I18n.t("active_admin.edit_#{active_admin_config.underscored_resource_name}"),
            edit_resource_path,
            :class => 'button icon edit') if can?(:edit, resource)
  end

  action_item :only => :show do
    link_to(I18n.t("active_admin.delete_#{active_admin_config.underscored_resource_name}"),
            resource.parent ? admin_parent_subdivision_subdivision_path(resource.parent, resource) : resource_path,
            :method => :delete,
            :confirm => I18n.t('active_admin.delete_confirmation'),
            :class => 'button icon trash danger') if can?(:destroy, resource)
  end

  menu :priority => 2

  index do
    render :partial => 'index'
  end

  show :title => proc { category.title } do
    div do
      render 'show', :children => category.children
    end
  end

  form :partial => 'form'

  collection_action :sort, :method => :post do
    index! do
      authorize! :manage, @parent_subdivision
      params[:ids].each_with_index do |id, index|
        subdivision = Subdivision.find(id)
        subdivision.update_attribute(:position, index.to_i+1)
      end
      head 200 and return
    end
  end

  controller do
    authorize_resource

    def index
      @cats = [Category.root] + Category.root.descendants.where(:type=> nil)
    end
  end
end
