ActiveAdmin.register Subdivision do
  menu false

  belongs_to :category, :optional => true

  config.clear_action_items!
  config.clear_sidebar_sections!

  actions :new, :create, :edit, :update, :index

  form :partial => 'form'

  controller do
    authorize_resource

    def create
      create! do |success, failure|
        success.html { redirect_to admin_category_path(@subdivision) }
      end
    end

    def update
      update! do |success, failure|
        success.html { redirect_to admin_category_path(@subdivision) }
      end
    end

    def index
      index! do
        redirect_to admin_category_path(@category) and return
      end
    end

    protected
      def collection_path
        admin_category_subdivisions_path(@category)
      end
  end
end
