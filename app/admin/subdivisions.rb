ActiveAdmin.register Subdivision do
  filter :title
  filter :updated_at

  index do
    column :title do |subdivision|
      link_to subdivision.title, admin_subdivision_path(subdivision)
    end
    column :abbr
    column :updated_at
  end

  show :title => proc { subdivision.title } do
    render 'subdivision'
  end

  form do |f|
    f.inputs :title, :abbr
    f.buttons
  end
end
