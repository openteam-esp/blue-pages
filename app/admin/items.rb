# encoding: utf-8

ActiveAdmin.register Item do
  belongs_to :subdivision

  form :partial => 'form'

  controller do
    def smart_resource_url
      admin_subdivision_path(@subdivision)
    end

    def collection_url
      admin_subdivision_path(@subdivision)
    end
  end
end
