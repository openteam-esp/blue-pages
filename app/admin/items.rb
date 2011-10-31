# encoding: utf-8

ActiveAdmin.register Item do
  belongs_to :subdivision, :optional => true

  config.clear_action_items!

  config.sort_order = 'position'

  filter :subdivision
  filter :title
  filter :updated_at

  menu :priority => 4

  index do
    column :title do |item|
      link_to item.title, [:admin, item.subdivision, item]
    end
    column :person do |item|
      span :class => "nobr" do
        item.person.to_s
      end
    end
    column :subdivision
    column :updated_at do |item|
      span :class => "nobr" do
        l item.updated_at, :format => :long
      end
    end
  end

  show :title => :title do
    render "show"
  end

  form :partial => 'form'

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
    index! do
      authorize! :manage, @subdivision

      params[:ids].each_with_index do |id, index|
        item = Item.find(id)
        item.update_attribute(:position, index.to_i+1)
      end
      head 200 and return
    end
  end

  controller do
    authorize_resource

    def index
      index! do
        redirect_to admin_category_path(@subdivision) and return if @subdivision
      end
    end

    def collection_url
      admin_category_path(@subdivision)
    end
  end
end
