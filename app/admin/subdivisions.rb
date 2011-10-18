ActiveAdmin.register Subdivision do
  index :as => :blog do
    title :title_with_abbr
  end
  show :title => proc{subdivision.title}
end
