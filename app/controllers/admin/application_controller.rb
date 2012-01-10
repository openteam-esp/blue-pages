class Admin::ApplicationController < ApplicationController
  before_filter :authenticate_user!
  layout 'admin/with_tree'
  inherit_resources
  load_and_authorize_resource :except => :index
end
