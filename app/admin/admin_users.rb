ActiveAdmin.register AdminUser do
  config.clear_action_items!

  filter :email
  filter :name

  menu :priority => 5

  action_item :only => :index do
    link_to(I18n.t("active_admin.create_#{AdminUser.to_s.downcase}"),
            new_resource_path,
            :class => 'button icon add') if can?(:create, AdminUser)
  end

  action_item :only => :show do
    link_to(I18n.t("active_admin.edit_#{resource.class.to_s.downcase}"),
            edit_resource_path,
            :class => 'button icon edit') if can?(:edit, resource)
  end

  action_item :only => :show do
    link_to(I18n.t("active_admin.delete_#{resource.class.to_s.downcase}"),
            resource_path,
            :method => :delete,
            :confirm => I18n.t('active_admin.delete_confirmation'),
            :class => 'button icon trash danger') if can?(:destroy, resource)
  end

  index do
    column :name do |admin_user|
      link_to admin_user.name, admin_admin_user_path(admin_user)
    end
    column :email do |admin_user|
      mail_to admin_user.email
    end
    column :last_sign_in_at do |admin_user|
      span :class => "nobr" do
        l admin_user.last_sign_in_at, :format => :long
      end
    end
    column :last_sign_in_ip do |admin_user|
      span :class => "nobr" do
        admin_user.last_sign_in_ip
      end
    end
  end

  show :title => proc { admin_user.name } do
    div do
      render 'show'
    end
  end

  form :partial => 'form'

  controller do
    load_and_authorize_resource
  end
end
