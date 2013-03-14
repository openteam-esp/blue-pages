class Manage::UsersController < Manage::ApplicationController
  has_searcher

  actions :index

  has_scope :page, :default => 1

  layout 'manage/manage'

  protected

  def collection
    search_object = searcher_for(resource_instance_name)
    #search_object.permissions_count_gt = 1
    search_object.pagination = {:page => params[:page], :per_page => 10}
    search_object.order_by = 'uid' if search_object.term.blank?
    search_object.results
  end
end
