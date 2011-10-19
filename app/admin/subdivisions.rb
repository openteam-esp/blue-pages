ActiveAdmin.register Subdivision do
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
    render 'subdivisions', :subdivisions => subdivision.children.order('position')
  end

  form :partial => 'form'

  config.clear_action_items!

  action_item :only => :show do
    link_to(I18n.t('active_admin.edit_model', :model => active_admin_config.resource_name), edit_resource_path(resource))
  end

  action_item :only => :show do
    link_to(I18n.t('active_admin.delete_model', :model => active_admin_config.resource_name),
            resource_path(resource),
            :method => :delete, :confirm => I18n.t('active_admin.delete_confirmation'))
  end

  collection_action :sort, :method => :post do
    params[:ids].each_with_index do |id, index|
      subdivision = Subdivision.find(id)
      subdivision.update_attribute(:position, index.to_i+1)
    end
    head 200
  end
end
