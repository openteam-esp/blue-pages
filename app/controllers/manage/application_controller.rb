class Manage::ApplicationController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorize_manage_resource, :only => :show
  layout 'manage/with_tree'
  inherit_resources
  load_and_authorize_resource :except => :index

  private
    def authorize_manage_resource
      authorize! :manage, resource
    end
end
