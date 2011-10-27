ActiveAdmin.register AdminUser do
  filter :email
  filter :name

  index do
    column :name do |admin_user|
      link_to admin_user.name, admin_admin_user_path(admin_user)
    end
    column :email
    column :last_sign_in_at
    column :last_sign_in_ip
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
