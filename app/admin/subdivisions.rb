ActiveAdmin.register Subdivision do
  filter :title
  filter :updated_at
  index :as => :blog do
    title :title_with_abbr
  end
  show :title => proc{subdivision.title}
end
