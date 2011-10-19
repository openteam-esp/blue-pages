# encoding: utf-8

ActiveAdmin.register Item do
  belongs_to :subdivision

  form :partial => 'form'

  controller do
    def create
      create! do |format|
        format.html { redirect_to admin_subdivision_path(@subdivision) }
      end
    end
  end
end
