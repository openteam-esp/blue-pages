class Admin::ApplicationController < ApplicationController
  inherit_resources
  before_filter :authenticate_user!
  layout 'admin/with_tree'
end
