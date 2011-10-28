ActiveAdmin.register AdminUser do
  filter :email
  filter :name

  menu :priority => 5

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
    authorize_resource
  end
end
