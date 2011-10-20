# encoding: utf-8

ActiveAdmin.register Item do
  belongs_to :subdivision, :optional => true

  form :partial => 'form'

  index do
    column :subdivision
    column :title do |item|
      link_to item.title, [:admin, item.subdivision, item]
    end
    column :person do |item|
      item.person.to_s
    end
    column :updated_at
  end

  show :title => :title do
    render "item"
  end

  config.clear_action_items!

  action_item :only => :show do
    link_to(I18n.t("active_admin.edit_#{active_admin_config.underscored_resource_name}"), edit_resource_path, :class => 'button icon edit')
  end

  action_item :only => :show do
    link_to(I18n.t("active_admin.delete_#{active_admin_config.underscored_resource_name}"),
            resource_path,
            :method => :delete, :confirm => I18n.t('active_admin.delete_confirmation'), :class => 'button icon trash danger')
  end

  controller do

    def index
      index! do
        redirect_to admin_subdivision_path(@subdivision) and return if @subdivision
      end
    end

    def collection_url
      admin_subdivision_path(@subdivision)
    end
  end
end
