ActiveAdmin.register Subdivision do
  belongs_to :parent_subdivision, :optional => true, :class_name => 'Subdivision'
  filter :title
  filter :updated_at
  config.sort_order = 'position'

  index do
    column :title do |subdivision|
      link_to subdivision.title, admin_subdivision_path(subdivision)
    end
    column :abbr
    column :updated_at
  end

  show :title => proc { subdivision.title } do
    div do
      render 'show', :items => subdivision.items, :subdivisions => subdivision.children.order('position')
    end
  end

  form :partial => 'form'

  config.clear_action_items!

  action_item :only => :show do
    link_to(I18n.t("active_admin.edit_#{active_admin_config.underscored_resource_name}"),
            edit_resource_path,
            :class => 'button icon edit') if can?(:manage, resource)
  end

  action_item :only => :show do
    link_to(I18n.t("active_admin.delete_#{active_admin_config.underscored_resource_name}"),
            resource_path,
            :method => :delete,
            :confirm => I18n.t('active_admin.delete_confirmation'),
            :class => 'button icon trash danger') if can?(:manage, resource)
  end

  collection_action :sort, :method => :post do
    params[:ids].each_with_index do |id, index|
      subdivision = Subdivision.find(id)
      subdivision.update_attribute(:position, index.to_i+1)
    end
    head 200
  end

  controller do
    load_and_authorize_resource

    def current_ability
      @current_ability ||= Ability.new(current_admin_user)
    end

    def index
      index! do
        redirect_to admin_subdivision_path(@parent_subdivision) and return if @parent_subdivision
      end
    end

    def collection_path
      return admin_parent_subdivision_subdivisions_path(@parent_subdivision) if @parent_subdivision
      admin_subdivisions_path
    end
  end
end
